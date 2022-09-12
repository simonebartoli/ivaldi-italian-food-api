import {Arg, Int, Mutation, Query, Resolver} from "type-graphql";
import prisma from "../../db/prisma";
import {Category} from "../types/categoryType";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {RequireAdmin} from "../custom-decorator/requireAdmin";
import {ModifyCategoryDetailsInput} from "../inputs/modifyCategoryDetailsInput";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import {AddNewCategoryInput} from "../inputs/addNewCategoryInput";

@Resolver()
export class CategoryResolvers {

    @Query(returns => [Category])
    async getCategories_FULL(): Promise<Category[]>{
        return await prisma.categories.findMany()
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @RequireAdmin()
    async modifyCategoryDetails(@Arg("data", returns => ModifyCategoryDetailsInput) inputData: ModifyCategoryDetailsInput) {
        const {category_id, name, subCategories} = inputData
        if(await prisma.categories.findUnique({where: {category_id: category_id}}) === null){
            throw new DATA_ERROR("Category ID Not Valid", DATA_ERROR_ENUM.CATEGORY_NOT_FOUND)
        }
        if(name) {
            const result = await prisma.categories.findUnique({where: {name: name}})
            if(result !== null) throw new DATA_ERROR("Category Name Already Existing", DATA_ERROR_ENUM.CATEGORY_NAME_DUPLICATED)
            await prisma.categories.update({
                where: {
                    category_id: category_id
                },
                data: {
                    name: name
                }
            })
        }
        if(subCategories){
            const resultSubFound = await prisma.sub_categories.findMany({
                where: {
                    name: {
                        in: subCategories
                    }
                }
            })
            const resultSubNotFound = await prisma.sub_categories.findMany({
                where: {
                    name: {
                        notIn: subCategories,
                    },
                    category_id: category_id
                }
            })
            console.log("FOUND ")
            console.log(resultSubFound)

            console.log("NOT FOUND ")
            console.log(resultSubNotFound)


            const subToAdd = (() => {
                const categories: string[] = []
                subCategories.forEach(_ => {
                    if(!resultSubFound.map(__ => __.name).includes(_)){
                        categories.push(_)
                    }
                })
                return categories
            })()
            console.log("ADD ")
            console.log(subToAdd)

            await prisma.$transaction(async prisma => {
                await prisma.sub_categories.updateMany({
                    where: {
                        name: {
                            in: resultSubFound.map(_ => _.name)
                        }
                    },
                    data: {
                        category_id: category_id
                    }
                })
                await prisma.sub_categories.deleteMany({
                    where: {
                        name: {
                            in: resultSubNotFound.map(_  => _.name)
                        }
                    }
                })
                await prisma.sub_categories.createMany({
                    data: subToAdd.map(_ => {
                        return {
                            name: _,
                            category_id: category_id
                        }
                    })
                })
            })
        }


        return true
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @RequireAdmin()
    async addNewCategory(@Arg("data", returns => AddNewCategoryInput) inputData: AddNewCategoryInput) {
        const {name, subCategories} = inputData

        const result = await prisma.categories.findUnique({where: {name: name}})
        if(result !== null) throw new DATA_ERROR("Category Name Already Existing", DATA_ERROR_ENUM.CATEGORY_NAME_DUPLICATED)
        const resultNewCategory = await prisma.categories.create({
            data: {
                name: name
            }
        })


        const resultSubFound = await prisma.sub_categories.findMany({
            where: {
                name: {
                    in: subCategories
                }
            }
        })
        console.log("FOUND ")
        console.log(resultSubFound)

        const subToAdd = (() => {
            const categories: string[] = []
            subCategories.forEach(_ => {
                if(!resultSubFound.map(__ => __.name).includes(_)){
                    categories.push(_)
                }
            })
            return categories
        })()
        console.log("ADD ")
        console.log(subToAdd)

        await prisma.$transaction(async prisma => {
            await prisma.sub_categories.updateMany({
                where: {
                    name: {
                        in: resultSubFound.map(_ => _.name)
                    }
                },
                data: {
                    category_id: resultNewCategory.category_id
                }
            })
            await prisma.sub_categories.createMany({
                data: subToAdd.map(_ => {
                    return {
                        name: _,
                        category_id: resultNewCategory.category_id
                    }
                })
            })
        })



        return true
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @RequireAdmin()
    async removeCategory(@Arg("category_id", returns => Int) category_id: number) {
        await prisma.categories.delete({
            where: {
                category_id: category_id
            }
        })
        return true
    }


    // @Query(returns => [Category])
    /*async getCategories_pagination(@Args() {limit, offset}: PaginationInterface): Promise<Category[]>{
        return await prisma.categories.findMany({
            skip: offset,
            take: limit
        })
    }*/

    // @Query(returns => [Category])
    /*async getCategories_cursor(@Args() {cursor, limit}: CursorInterface): Promise<Category[]>{
        if(cursor === undefined || cursor === null){
            return await prisma.categories.findMany({
                take: limit
            })
        }
        return await prisma.categories.findMany({
            cursor: {
                category_id: cursor
            },
            skip: 1,
            take: limit
        })
    }*/

}