import cron from "node-cron"
import {createPublicPrivateKeys} from "../schema/lib/accessLib";

export const initKeyRotation = () => {
    cron.schedule("* * * */7 * *",
        () => createPublicPrivateKeys(),
        {
            scheduled: true
        }
    )
    createPublicPrivateKeys()
}