import {Arg, Ctx, Mutation, Resolver} from "type-graphql";
import prisma from "../../db/prisma";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {Context} from "../types/not-graphql/contextType";
import {AddAddressInput} from "../inputs/addAddressInput";
import {INTERNAL_ERROR} from "../../errors/INTERNAL_ERROR";
import {INTERNAL_ERROR_ENUM} from "../enums/INTERNAL_ERROR_ENUM";
import axios from "axios";
import {EditAddressInput} from "../inputs/editAddressInput";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import {RemoveAddressInput} from "../inputs/removeAddressInput";

@Resolver()
export class AddressResolvers {

    async getCoordinates(first_address : string, second_address : string | undefined, postcode : string, city : string): Promise<string | null> {
        let coordinates: string | null = null
        type openStreetMapFetchResultType = {
            lat: string,
            lon: string
        }

        const query = (first_address + " " + (second_address !== undefined ? second_address?.replace(/\d/g, '') : "")  + " " + postcode + " " + city).trim()

        const openStreetMapURL = `https://nominatim.openstreetmap.org/search?q=${query}&format=json&email=simone.bartoli01@gmail.com&accept-language=en-GB`

        try{
            const result = await axios.get(openStreetMapURL)
            const resultJSON = result.data as openStreetMapFetchResultType[]

            if(resultJSON[0] !== undefined){
                coordinates = resultJSON[0].lat + ", " + resultJSON[0].lon
            }
        }catch (e) {
            console.log((e as Error).message)
        }
        return coordinates
    }


    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    async addNewAddress(@Ctx() ctx: Context, @Arg("data") inputData: AddAddressInput): Promise<true> {
        const {user_id} = ctx
        const {first_address, second_address, postcode, city, country, notes, type} = inputData
        const coordinates = await this.getCoordinates(first_address, second_address, postcode, city)

        try{
            if(type === "SHIPPING"){
                const result = await prisma.addresses.create({
                    data: {
                        first_address: first_address,
                        second_address: second_address,
                        postcode: postcode,
                        city: city,
                        notes: notes,
                        coordinates: coordinates,
                        user_id: user_id!,
                    }
                })
                await prisma.shipping_addresses.create({
                    data: {
                        address_id: result.address_id
                    }
                })
            }else{
                const result = await prisma.addresses.create({
                    data: {
                        first_address: first_address,
                        second_address: second_address,
                        postcode: postcode,
                        city: city,
                        notes: notes,
                        coordinates: coordinates,
                        user_id: user_id!,
                    }
                })
                await prisma.billing_addresses.create({
                    data: {
                        address_id: result.address_id,
                        country: country
                    }
                })
            }
        }catch (e) {
            throw new INTERNAL_ERROR("DB Problem", INTERNAL_ERROR_ENUM.DB_ERROR)
        }

        return true
    }


    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    async editExistingAddress(@Ctx() ctx: Context, @Arg("data") inputData: EditAddressInput): Promise<true>{
        const {address_id, first_address, second_address, postcode, city, country, notes} = inputData
        const {user_id} = ctx

            if(country !== undefined){
                try {
                    await prisma.addresses.findFirstOrThrow({
                        where: {
                            address_id: address_id,
                            user_id: user_id!,
                            billing_addresses: {
                                address_id: address_id
                            }
                        }
                    })
                }catch (e) {
                    throw new DATA_ERROR("A Shipping Address Cannot have Country Param", DATA_ERROR_ENUM.ADDRESS_NOT_EXISTING)
                }
            }else {
                try{
                    await prisma.addresses.findFirstOrThrow({
                        where: {
                            address_id: address_id,
                            user_id: user_id!
                        }
                    })
                }catch (e) {
                    throw new DATA_ERROR("Address Not Found", DATA_ERROR_ENUM.ADDRESS_NOT_EXISTING)
                }
            }



        try{
            const result = country === undefined ?
                await prisma.addresses.update({
                    where: {
                        address_id: address_id
                    },
                    data: {
                        first_address: first_address,
                        second_address: second_address,
                        postcode: postcode,
                        city: city,
                        notes: notes
                    }
                })
                :
                await prisma.addresses.update({
                    where: {
                        address_id: address_id
                    },
                    data: {
                        first_address: first_address,
                        second_address: second_address,
                        postcode: postcode,
                        city: city,
                        notes: notes,
                        billing_addresses: {
                            update: {
                                country: country
                            }
                        }
                    }
                })

            const coordinates = await this.getCoordinates(result.first_address, result.second_address === null ? undefined : result.second_address, result.postcode, result.city)
            if(coordinates !== result.coordinates) {
                await prisma.addresses.update({
                    where: {
                        address_id: address_id
                    },
                    data: {
                        coordinates: coordinates
                    }
                })
            }

        }catch (e) {
            console.log(e)
            throw new INTERNAL_ERROR("DB Problem", INTERNAL_ERROR_ENUM.DB_ERROR)
        }
        return true
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    async removeAddress(@Ctx() ctx: Context, @Arg("data") inputData: RemoveAddressInput): Promise<true>{
        const {address_id} = inputData
        const {user_id} = ctx

        try{
            await prisma.addresses.findFirst({
                where: {
                    address_id: address_id,
                    user_id: user_id!
                }
            })
        }catch (e) {
            throw new DATA_ERROR("Address Not Found", DATA_ERROR_ENUM.ADDRESS_NOT_EXISTING)
        }

        try{
            await prisma.addresses.delete({
                where: {
                    address_id: address_id,
                }
            })
        }catch (e) {
            console.log(e)
            throw new INTERNAL_ERROR("DB Problem", INTERNAL_ERROR_ENUM.DB_ERROR)
        }
        return true
    }

}