import {Arg, Args, Ctx, Int, Mutation, Query, Resolver} from "type-graphql";
import prisma from "../../db/prisma";
import {Item} from "../types/itemType";
import {PaginationInterface} from "../args/paginationInterface";
import {GetItemsArgs} from "../args/getItemsArgs";
import {searchProducts, SearchResult} from "../lib/searchLib";
import {Context} from "../types/not-graphql/contextType";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import {BAD_REQ_ERROR} from "../../errors/BAD_REQ_ERROR";
import {BAD_REQ_ERROR_ENUM} from "../enums/BAD_REQ_ERROR_ENUM";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {RequireAdmin} from "../custom-decorator/requireAdmin";
import {ModifyItemDetailsInput} from "../inputs/modifyItemDetailsInput";
import {DateTime} from "luxon";
import {AddNewItemInput} from "../inputs/addNewItemInput";
import axios from "axios";
import {DOMAIN, REVALIDATE_TOKEN} from "../../bin/settings";

@Resolver()
export class ItemResolvers {

    @Query(returns => Item)
    async getItem(@Arg("id", type => Int) id: number): Promise<Item> {
        const result = await prisma.items.findUnique({
            where: {
                item_id: id
            }
        })
        if(result === null) throw new DATA_ERROR("Item Not Existing", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)
        return result
    }

    @Query(returns => String)
    async getKeywordsItem(@Arg("id", type => Int) id: number): Promise<string> {
        const resultKeywords = await prisma.keywords.findMany({
            where: {
                item_id: id
            }
        })
        const categoriesID: number[] = []

        const resultSubCategories = await prisma.sub_categories_items.findMany({
            include: {
                sub_categories: true
            },
            where: {
                item_id: id
            }
        })
        resultSubCategories.forEach(element => categoriesID.push(element.sub_categories.category_id))
        const resultCategories = resultSubCategories.length === 0 ? await prisma.categories_items.findMany({
            include: {
                categories: true
            },
            where: {
                item_id: id
            }

        }) : []
        resultCategories.forEach(element => categoriesID.push(element.category_id))

        const categoryInformation = await prisma.categories.findMany({
            where: {
                category_id: {
                    in: categoriesID
                }
            }
        })
        const formatString = (element: string): string => {
            const keywords = element.split(" ")
            let result: string = ""
            keywords.forEach(element => result = element + ",")
            return result
        }

        let result: string = ""
        resultKeywords.forEach(element => result += formatString(element.keyword))
        resultSubCategories.forEach(element => result += formatString(element.sub_categories.name))
        categoryInformation.forEach(element => result += formatString(element.name))

        return result
    }

    @Query(returns => [Item])
    async getItems_FULL(@Args() options: GetItemsArgs, @Ctx() ctx: Context): Promise<Item[]>{
        const {discountOnly = false, priceRange = undefined, outOfStock = false, keywords, priority} = options
        const {max, min} = priceRange || {}

        let productsID: number[] | undefined = undefined
        let products: SearchResult

        if(keywords !== "All Products"){
            products = await searchProducts(keywords, ctx)
            productsID = [...products.keys()]
        }


        const result = await prisma.items.findMany({
            where: {
                NOT: {
                    discount_id: !discountOnly ? undefined : null
                },
                item_id: {
                  in: productsID
                },
                amount_available: {
                    gte: outOfStock ? 0 : 1
                },
                price_total: {
                    gte: min,
                    lte: max
                },
                priority: priority
            },
            orderBy: {
                price_total: "asc"
            }
        })
        return result.map((element) => {
            return {
                ...element,
                importance: products?.get(element.item_id)
            }
        })
    }

    @Query(returns => [Item])
    async getItems_pagination(@Args() {limit, offset}: PaginationInterface, @Args() options: GetItemsArgs, @Ctx() ctx: Context): Promise<Item[]>{
        const {discountOnly = false, priceRange, outOfStock = false, keywords, order = "Most Relevant"} = options
        const {max, min} = priceRange || {}

        let productsID: number[] | undefined = undefined
        let products: SearchResult

        if(keywords !== "All Products"){
            let category = await prisma.categories.findFirst({
                where: {
                    OR: [
                        {
                            name: {
                                mode: "insensitive",
                                equals: keywords
                            }
                        }
                    ]
                }
            })
            if(category === null){
                products = await searchProducts(keywords, ctx)
                productsID = [...products.keys()]
            }else{
                const productsCategory = await prisma.categories_items.findMany({
                    where: {
                        category_id: category.category_id
                    }
                })
                productsID = [...productsCategory.map(_ => _.item_id)]
            }
        }

        const result = await prisma.items.findMany({
            include: {
              discounts: true
            },
            where: {
                NOT: {
                    discount_id: !discountOnly ? undefined : null
                },
                item_id: {
                    in: productsID
                },
                amount_available: {
                    gte: outOfStock ? 0 : 1
                },
                price_total: {
                    gte: min,
                    lte: max
                }
            }
        })
        let resultFormatted = result.map((element) => {
            return {
                ...element,
                importance: products?.get(element.item_id)
            }
        })
        switch (order) {
            case "Most Relevant":
                resultFormatted = resultFormatted.sort((a, b) => {
                    if(a.importance === undefined || b.importance === undefined){
                        return -1
                    }else{
                        if(a.importance < b.importance){
                            return 1
                        }else{
                            return -1
                        }
                    }
                })
                break
            case "Price Ascending":
                resultFormatted = resultFormatted.sort((a, b) => {
                    if(a.price_total > b.price_total){
                        return 1
                    }else{
                        return -1
                    }
                })
                break
            case "Price Descending":
                resultFormatted = resultFormatted.sort((a, b) => {
                    if(a.price_total > b.price_total){
                        return -1
                    }else{
                        return 1
                    }
                })
                break
            case "Higher Discounts":
                resultFormatted = resultFormatted.sort((a, b) => {
                    if(a.discounts === null && b.discounts !== null){
                        return 1
                    }else if (a.discounts !== null && b.discounts === null){
                        return -1
                    }else if(a.discounts === null && b.discounts === null){
                        return -1
                    }else if(a.discounts !== null && b.discounts !== null) {
                       if(a.discounts.percentage > b.discounts.percentage){
                           return -1
                       }else{
                           return 1
                       }
                    }
                    return -1
                })
                break
            default:
                throw new BAD_REQ_ERROR("Order Parameter Not Valid", BAD_REQ_ERROR_ENUM.INVALID_PARAMETER_VALUE)
        }

        return resultFormatted.slice(offset, limit)
    }


    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @RequireAdmin()
    async addNewItem(@Ctx() ctx: Context, @Arg("data", returns => AddNewItemInput) inputData: AddNewItemInput){
        const {name, description, price_total, price_unit, amount_available, discount, vat, keyword, category, photo_loc} = inputData

        const categoryToAddRedis: string[] = []

        let vatID: number
        let discountID: number | null
        let dbCategoryID: number[] = []
        let dbSubCategoryID: number[] = []

        const resultDBName = await prisma.items.findUnique({
            where: {
                name: name
            }
        })
        if(resultDBName !== null) throw new DATA_ERROR("Name Already Used", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)

        const resultDBVat = await prisma.vat.findUnique({
            where: {
                percentage: vat
            }
        })
        if(resultDBVat === null) throw new DATA_ERROR("VAT Not Registered", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)
        vatID = resultDBVat.vat_id

        if(discount === 0){
            discountID = null
        }else{
            const result = await prisma.discounts.findFirst({
                where: {
                    percentage: discount
                }
            })
            if(result === null){
                discountID = (await prisma.discounts.create({
                    data: {
                        percentage: discount
                    }
                })).discount_id
            }else{
                discountID = result.discount_id
            }
        }

        let resultDBCategory
        for(const cat of category){
            try{
                resultDBCategory = await prisma.categories.findFirst({
                    where: {
                        name: cat
                    }
                })
                if(resultDBCategory === null) {
                    resultDBCategory = await prisma.sub_categories.findFirstOrThrow({
                        include: {
                            categories: true
                        },
                        where: {
                            name: cat
                        }
                    })
                    categoryToAddRedis.push(resultDBCategory.name)
                    categoryToAddRedis.push(resultDBCategory.categories.name)

                    dbSubCategoryID.push(resultDBCategory.sub_category_id)
                }else{
                    categoryToAddRedis.push(resultDBCategory.name)
                    dbCategoryID.push(resultDBCategory.category_id)
                }
            }catch (e) {
                throw new DATA_ERROR("Category is Invalid", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)
            }
        }

        const resultDBItemAdded = await prisma.items.create({
            data: {
                name: name,
                description: description,
                price_total: price_total,
                price_unit: price_unit,
                amount_available: amount_available,
                vat_id: vatID,
                entry_date: DateTime.now().toJSDate(),
                discount_id: discountID,
                photo_loc: photo_loc
            }
        })
        const item_id = resultDBItemAdded.item_id

        for(const cat of categoryToAddRedis){
            await ctx.redis.SADD(cat.toLowerCase(), String(item_id))
        }

        if(dbCategoryID.length > 0){
            const categoryCreateObject = dbCategoryID.map((element) => {
                return {
                    item_id: item_id,
                    category_id: element
                }
            })
            await prisma.categories_items.createMany({
                data: categoryCreateObject
            })
        }
        if(dbSubCategoryID.length > 0){
            const subCategoryCreateObject = dbSubCategoryID.map((element) => {
                return {
                    item_id: item_id,
                    sub_category_id: element
                }
            })
            await prisma.sub_categories_items.createMany({
                data: subCategoryCreateObject
            })
        }

        const keywordCreateObject = keyword.map((element) => {
            return {
                item_id: item_id,
                keyword: element
            }
        })
        await prisma.keywords.createMany({
            data: keywordCreateObject
        })
        for(const key of keyword){
            await ctx.redis.SADD(key.toLowerCase(), String(item_id))
        }

        const nameArray = resultDBItemAdded.name.split(" ").filter(_ => _.length > 2)
        for(const name of nameArray){
            await ctx.redis.SADD(name.toLowerCase(), String(item_id))
        }


        return true
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @RequireAdmin()
    async modifyItemDetails(@Ctx() ctx: Context, @Arg("data", returns => ModifyItemDetailsInput) inputData: ModifyItemDetailsInput) {
        const {item_id, name, description, price_total, price_unit, amount_available, discount, vat, keyword, category, photo_loc, priority} = inputData

        let vatID: number | undefined = undefined
        let discountID: number | null | undefined = undefined
        let dbCategoryID: number[] | undefined = undefined
        let dbSubCategoryID: number[] | undefined = undefined

        const product = await prisma.items.findUnique({
            include: {
                keywords: true,
                sub_categories_items: {
                    include: {
                        sub_categories: {
                            include: {
                                categories: true
                            }
                        }
                    }
                },
                categories_items: {
                    include: {
                        categories: true
                    }
                }
            },
            where: {
                item_id: item_id
            }
        })

        if(product === null){
            throw new DATA_ERROR("Item Not Existing", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)
        }

        if(name !== undefined) {
            const result = await prisma.items.findUnique({
                where: {
                    name: name
                }
            })
            if(result !== null) throw new DATA_ERROR("Name Already Used", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)
            const arrayOfNamesToInsert = name.split(" ").filter(_ => _.length > 2)
            const arrayProductName = product.name.split(" ").filter(_ => _.length > 2)

            for(const name of arrayProductName){
                await ctx.redis.SREM(name, String(item_id))
            }
            for(const name of arrayOfNamesToInsert){
                await ctx.redis.SADD(name.toLowerCase(), String(item_id))
            }
        }
        if(vat !== undefined){
            const result = await prisma.vat.findUnique({
                where: {
                    percentage: vat
                }
            })
            if(result === null) throw new DATA_ERROR("VAT Not Registered", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)
            vatID = result.vat_id
        }
        if(discount !== undefined) {
            if(discount === 0){
                discountID = null
            }else{
                const result = await prisma.discounts.findFirst({
                    where: {
                        percentage: discount
                    }
                })
                if(result === null){
                    discountID = (await prisma.discounts.create({
                        data: {
                            percentage: discount
                        }
                    })).discount_id
                }else{
                    discountID = result.discount_id
                }
            }
        }
        if(category !== undefined){
            dbCategoryID = []
            dbSubCategoryID = []

            const categoryToRemove = (() => {
                const array: string[] = []
                product.categories_items.forEach(_ => {
                    array.push(_.categories.name)
                })
                product.sub_categories_items.forEach(_ => {
                    array.push(_.sub_categories.name)
                })
                product.sub_categories_items.forEach(_ => {
                    array.push(_.sub_categories.categories.name)
                })
                return array
            })()
            for(const catToRemove of categoryToRemove){
                await ctx.redis.SREM(catToRemove.toLowerCase(), String(item_id))
            }

            let result
            for(const cat of category){
                try{
                    result = await prisma.categories.findFirst({
                        where: {
                            name: cat
                        }
                    })
                    if(result === null) {
                        result = await prisma.sub_categories.findFirstOrThrow({
                            include: {
                                categories: true
                            },
                            where: {
                                name: cat
                            }
                        })
                        await ctx.redis.SADD(cat.toLowerCase(), String(item_id))
                        await ctx.redis.SADD(result.categories.name.toLowerCase(), String(item_id))
                        dbSubCategoryID.push(result.sub_category_id)
                    }else{
                        await ctx.redis.SADD(cat.toLowerCase(), String(item_id))
                        dbCategoryID.push(result.category_id)
                    }
                }catch (e) {
                    throw new DATA_ERROR("Category is Invalid", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)
                }
            }
        }

        if(dbCategoryID !== undefined){
            await prisma.categories_items.deleteMany({
                where: {
                    item_id: item_id
                }
            })
            const categoryCreateObject = dbCategoryID.map((element) => {
                return {
                    item_id: item_id,
                    category_id: element
                }
            })
            await prisma.categories_items.createMany({
                data: categoryCreateObject
            })
        }
        if(dbSubCategoryID !== undefined){
            await prisma.sub_categories_items.deleteMany({
                where: {
                    item_id: item_id
                }
            })
            const subCategoryCreateObject = dbSubCategoryID.map((element) => {
                return {
                    item_id: item_id,
                    sub_category_id: element
                }
            })
            await prisma.sub_categories_items.createMany({
                data: subCategoryCreateObject
            })
        }
        if(keyword !== undefined){
            await prisma.keywords.deleteMany({
                where: {
                    item_id: item_id
                }
            })
            const keywordCreateObject = keyword.map((element) => {
                return {
                    item_id: item_id,
                    keyword: element
                }
            })
            await prisma.keywords.createMany({
                data: keywordCreateObject
            })

            for(const key of product.keywords){
                await ctx.redis.SREM(key.keyword, String(item_id))
            }
            for(const key of keyword){
                await ctx.redis.SADD(key.toLowerCase(), String(item_id))
            }
        }

        await prisma.items.update({
            where: {
                item_id: item_id
            },
            data: {
                name: name,
                description: description,
                price_total: price_total,
                price_unit: price_unit,
                amount_available: amount_available,
                vat_id: vatID,
                entry_date: DateTime.now().toJSDate(),
                discount_id: discountID,
                photo_loc: photo_loc,
                priority: priority
            }
        })
        try{
            console.log(`${DOMAIN}/api/revalidate?secret=${REVALIDATE_TOKEN}&id=${item_id}`)
            const response = await axios.get(`${DOMAIN}/api/revalidate?secret=${REVALIDATE_TOKEN}&id=${item_id}`)
            console.log(response.data)
        }catch (e) {
            console.log((e as Error).message)
        }

        return true
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @RequireAdmin()
    async removeItem(@Arg("item_id", returns => Int) item_id: number){
        await prisma.items.delete({
            where: {
                item_id: item_id
            }
        })
        try{
            console.log(`${DOMAIN}/api/revalidate?secret=${REVALIDATE_TOKEN}&id=${item_id}`)
            const response = await axios.get(`${DOMAIN}/api/revalidate?secret=${REVALIDATE_TOKEN}&id=${item_id}`)
            console.log(response.data)
        }catch (e) {
            console.log((e as Error).message)
        }
        return true
    }


    @Query(returns => [String])
    async getKeywords() {
        return (await prisma.keywords.findMany()).map(_ => _.keyword)
    }

    // @Query(returns => [Item])
/*
    async getItems_cursor(@Args() {cursor, limit}: CursorInterface, @Args() options: GetItemsArgs, @Ctx() ctx: Context): Promise<Item[]>{
        const {discountOnly = false, priceRange, outOfStock = false, keywords} = options
        const {max, min} = priceRange || {}

        let products: SearchResult | undefined = keywords !== undefined ? await searchProducts(keywords, ctx) : undefined
        const productsID = products !== undefined ? [...products.keys()] : undefined

        if(cursor === undefined || cursor === null){
            const result = await prisma.items.findMany({
                take: limit,
                where: {
                    NOT: {
                        discount_id: !discountOnly ? undefined : null
                    },
                    item_id: {
                        in: productsID
                    },
                    amount_available: {
                        gte: outOfStock ? 0 : 1
                    },
                    price_total: {
                        gte: min,
                        lte: max
                    }
                }
            })
            return result.map((element) => {
                return {
                    ...element,
                    importance: products?.get(element.item_id)
                }
            })
        }
        const result = await prisma.items.findMany({
            cursor: {
                item_id: cursor
            },
            skip: 1,
            take: limit,
            where: {
                NOT: {
                    discount_id: !discountOnly ? undefined : null
                },
                amount_available: {
                    gte: outOfStock ? 0 : 1
                },
                price_total: {
                    gte: min,
                    lte: max
                }
            }
        })
        return result.map((element) => {
            return {
                ...element,
                importance: products?.get(element.item_id)
            }
        })
    }
*/

}