import {ArgsType, Field, Int} from "type-graphql";

@ArgsType()
export class GetItemsCursorArgs {
    @Field(type => Int, {nullable: true})
    cursor?: number

    @Field(type => Int)
    limit: number
}