import express from "express";
import {secureUploadLink} from "../bin/www";
import {DateTime} from "luxon";
import path from "path";
import {UploadedFile} from "express-fileupload";

export const uploadRouter = express.Router()
uploadRouter.post("/api/upload/:token", async (req, res) => {
    const token = req.params.token
    const access = secureUploadLink.get(token)
    if(access === undefined) {
        return res.status(400).json({error: "Token Not Valid"})
    }else if(DateTime.fromJSDate(access) < DateTime.now()){
        secureUploadLink.delete(token)
        return res.status(400).json({error: "Token Expired"})
    }
    secureUploadLink.delete(token)

    if (!req.files || Object.keys(req.files).length === 0 || !req.files["image"]) {
        return res.status(400).json({error: "No file uploaded"});
    }
    const image = req.files["image"] as UploadedFile
    const uploadPath = path.join(process.cwd() + "/images/" + token + ".png")
    try{
        await image.mv(uploadPath)
    }catch (e) {
        return res.status(500).json({error: "Server Error"});
    }

    return res.status(200).json({message: `/images/${token}.png`})
});
