export type PublicKeyType = {
    kid: string
    expired: number
    content: {
        kty: string
        n: string
        e: string
    }
}

export type PrivateKeyType = {
    kid: string
    expired: number
    retired: number
    content: {
        kty: string
        n: string
        e: string
        d: string
        p: string
        q: string
        dp: string
        dq: string
        qi: string
    }
}