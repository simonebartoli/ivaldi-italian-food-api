import {Field, InputType, Int} from "type-graphql";


@InputType()
export class ModifyCategoryDetailsInput {
    @Field(type => Int)
    category_id: number

    @Field(type => String, {nullable: true})
    name?: string

    @Field(type => [String], {nullable: true})
    subCategories?: string[]
}