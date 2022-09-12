import {Field, InputType} from "type-graphql";

@InputType()
export class AddNewCategoryInput {
    @Field()
    name: string

    @Field(type => [String])
    subCategories: string[]
}