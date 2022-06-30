// import {addDiscountsToItems} from "./discounts_items";
// import {addCategoriesSubCategoriesToItems} from "./categories_items";

import {addOrders} from "./orders";

function generateData () {
    // addDiscountsToItems()
    //     .then(() => console.log("Discount Items Finished"))
    //     .catch((e) => console.log(e))
    // addCategoriesSubCategoriesToItems()
    //     .then(() => console.log("Categories Sub Categories Finished"))
    //     .catch((e) => console.log(e))
    addOrders()
        .then(() => console.log("Orders Finished"))
        .catch((e) => console.log(e))
}

generateData()