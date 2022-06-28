import {ArgsType, Field, Int} from "type-graphql";

@ArgsType()
export class GetItemsPaginationArgs {
    @Field(type => Int)
    limit: number

    @Field(type => Int)
    offset: number
}