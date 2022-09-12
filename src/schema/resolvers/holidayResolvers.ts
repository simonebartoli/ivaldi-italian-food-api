import {Arg, Mutation, Query, Resolver} from "type-graphql";
import {HolidayType} from "../types/holidayType";
import {DateTime} from "luxon";
import prisma from "../../db/prisma";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {RequireAdmin} from "../custom-decorator/requireAdmin";
import {CreateNewHolidayInput} from "../inputs/createNewHolidayInput";

@Resolver()
export class HolidayResolvers {

    @Query(returns => HolidayType)
    async getHolidays(): Promise<HolidayType> {
        const currentDate = DateTime.now().plus({day: 1})
        const result = await prisma.holidays.findFirst({
            where: {
                start_date: {
                    lte: currentDate.toJSDate()
                },
                end_date: {
                    gte: currentDate.toJSDate()
                }
            }
        })
        if(result === null) throw new DATA_ERROR("No Holidays Has Been Found", DATA_ERROR_ENUM.HOLIDAYS_NOT_FOUND)
        return result
    }

    @Query(returns => [HolidayType])
    async getHolidays_FULL(): Promise<HolidayType[]> {
        const currentDate = DateTime.now()
        return await prisma.holidays.findMany({
            where: {
                end_date: {
                    gte: currentDate.toJSDate()
                }
            }
        })
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @RequireAdmin()
    async createNewHoliday(@Arg("data", returns => CreateNewHolidayInput) inputData: CreateNewHolidayInput) {
        const {start_date, end_date} = inputData
        const date = DateTime.now()
        if(DateTime.fromJSDate(start_date) < date || DateTime.fromJSDate(end_date) < date || DateTime.fromJSDate(start_date) > DateTime.fromJSDate(end_date)) {
            throw new DATA_ERROR("Date Range is Invalid", DATA_ERROR_ENUM.DATE_NOT_VALID)
        }
        try{
            await prisma.holidays.create({
                data: {
                    start_date: start_date,
                    end_date: end_date
                }
            })
        }catch (e) {
            throw new DATA_ERROR("An Holiday with the same dates is already planned", DATA_ERROR_ENUM.DATE_NOT_VALID)
        }
        return true
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @RequireAdmin()
    async removeHoliday(@Arg("data", returns => CreateNewHolidayInput) inputData: CreateNewHolidayInput) {
        const {start_date, end_date} = inputData
        await prisma.holidays.delete({
            where: {
                start_date_end_date: {
                    start_date: start_date,
                    end_date: end_date
                }
            }
        })
        return true
    }
}