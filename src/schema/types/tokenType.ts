export type TokenHeaderType = {
    version: number
    kid: string
    token_id: number
    auth_level: string
}
export type TokenPayloadType = {
    id: number
    exp: number
}
