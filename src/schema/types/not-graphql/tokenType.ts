export type RefreshTokenHeaderType = {
    version: number
    kid: string
    token_id: number
    auth_level: string
}
export type RecoverTokenHeaderType = {
    kid: string
    token_id: number
}
export type AccessTokenHeaderType = {
    kid: string
    role: "client" | "admin"
    token_id: number
    auth_level: string
}
export type TokenPayloadType = {
    id: number
    exp: number
}
export type RecoverTokenPayloadType = {
    id: number
    email_to_verify: boolean
    exp: number
}
