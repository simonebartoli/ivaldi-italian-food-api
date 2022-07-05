import Stripe from "stripe";
const stripe = new Stripe(
    "sk_test_51LHx5kILFxyKM1mavm9KkwlqrDbwbMoi1s5Ubl6dH3czOuh0wDtZHqNRUGgCazOgcnBn6tC4opziNKsmArGFx6N300zNePi59F",
    {apiVersion: '2020-08-27'}
)

export const createPaymentIntent = async () => {
    await stripe.paymentIntents.create({
        amount: 1000,
        currency: "gbp",
        payment_method_types: ['card'],
    })
}