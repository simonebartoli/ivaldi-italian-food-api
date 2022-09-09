import cron from "node-cron"
import {createPublicPrivateKeys} from "../schema/lib/accessLib";

export const initKeyRotation = () => {
    cron.schedule("0 0 */7 * *",
        () => createPublicPrivateKeys(),
        {
            scheduled: true
        }
    )
    createPublicPrivateKeys()
}