import {Query, Resolver} from "type-graphql";
import {HolidayType} from "../types/holidayType";
import {DateTime} from "luxon";
import prisma from "../../db/prisma";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";

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
}