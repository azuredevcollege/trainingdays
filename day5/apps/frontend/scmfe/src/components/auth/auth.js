import * as msal from "@azure/msal-browser";
import store from "../../store";
const msalConfig = {
    auth: {
        clientId: `${window.uisettings.clientId}`,
        authority: `https://login.microsoftonline.com/${window.uisettings.tenantId}`,
        redirectUri: `${window.location.origin}`,
    }
};

const msalInstance = new msal.PublicClientApplication(msalConfig);
const loginRequest = {
    scopes: ["openid", "profile", "User.Read"]
};

const tokenRequest = {
    scopes: [
        `${window.uisettings.audience}/Contacts.Read`,
        `${window.uisettings.audience}/Contacts.Create`,
        `${window.uisettings.audience}/Contacts.Update`,
        `${window.uisettings.audience}/Contacts.Delete`,
        `${window.uisettings.audience}/VisitReports.Read`,
        `${window.uisettings.audience}/VisitReports.Create`,
        `${window.uisettings.audience}/VisitReports.Update`,
        `${window.uisettings.audience}/VisitReports.Create`
    ]
};

msalInstance.handleRedirectPromise().then(handleResponse).catch(err => {
    console.log(err)
});

function handleResponse(resp) {
    if (resp !== null) {
        msalInstance.setActiveAccount(resp.account);
        getAccessToken();
    } else {
        const currentAccounts = msalInstance.getAllAccounts();
        if (!currentAccounts || currentAccounts.length < 1) {
            return;
        } else if (currentAccounts.length > 1) {
            // Add choose account code here
        } else if (currentAccounts.length === 1) {
            msalInstance.setActiveAccount(currentAccounts[0]);
        }
    }
}


export function login() {
    msalInstance.loginRedirect(loginRequest);
}

export function getAccount() {
    let acc = msalInstance.getActiveAccount();
    console.log(acc);
    return acc;
}

export function logout() {
    store.commit("auth/clearAccount")
    msalInstance.logout();
}

export function isAuthenticated() {
    let actAccount = msalInstance.getActiveAccount();
    return actAccount != null || actAccount != undefined;
}

export function getAccessToken() {
    msalInstance.acquireTokenSilent(tokenRequest).then(result => {
        store.commit("auth/setAccessToken", result.accessToken)
        store.commit("auth/setAccount", msalInstance.getActiveAccount())
    }).catch(error => {
        if (error instanceof msal.InteractionRequiredAuthError) {
            console.log("acquiring token using popup");
            return msalInstance.acquireTokenPopup(tokenRequest).catch(error => {
                console.error(error);
            });
        } else {
            console.error(error);
        }
    })
}