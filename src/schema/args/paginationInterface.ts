import {ArgsType, Field, Int} from "type-graphql";

@ArgsType()
export class PaginationInterface {
    @Field(type => Int)
    limit: number

    @Field(type => Int)
    offset: number
}