
export const setHttpPlugin = {
    async requestDidStart() {
        return {
            async willSendResponse({response}: any) {

            }
        };
    }
};