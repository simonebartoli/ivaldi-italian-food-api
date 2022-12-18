// import {addDiscountsToItems} from "./discounts_items";
// import {addCategoriesSubCategoriesToItems} from "./categories_items";

// import {addOrders} from "./orders";

// import {addKeywordsToItem} from "./keywords";
// import {createPaymentIntent} from "./payment_intent";

// import {addCategoriesSubCategoriesToRedis} from "./categories_items";

// import {createPublicPrivateKeys} from "./key-rotation";

import {initWeight} from "./init_weight";

function generateData () {
    // addDiscountsToItems()
    //     .then(() => console.log("Discount Items Finished"))
    //     .catch((e) => console.log(e))
    // addCategoriesSubCategoriesToItems()
    //     .then(() => console.log("Categories Sub Categories Finished"))
    //     .catch((e) => console.log(e))
    // addOrders()
    //     .then(() => console.log("Orders Finished"))
    //     .catch((e) => console.log(e))
    // addKeywordsToItem()
    //     .then(() => console.log("Keywords Finished"))
    //     .catch((e) => console.log(e))
    // createPaymentIntent()
    //     .then(() => console.log("Payment Intent Finished"))
    //     .catch((e) => console.log(e))
    // addCategoriesSubCategoriesToRedis()
    //     .then(() => console.log("Categories Item Finished"))
    //     .catch((e) => console.log(e))

    // createPublicPrivateKeys()
    //     .then(() => console.log("Key Rotation Finished"))
    //     .catch((e) => console.log(e))

    initWeight()
        .then(() => console.log("Weight Finished"))
        .catch((e) => console.log(e))
}

generateData()