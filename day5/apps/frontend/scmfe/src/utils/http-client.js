import axios from "axios";
import {getAccessTokenSilent} from "../components/auth/auth";
const BASE_URL = window.uisettings.endpoint;
const BASE_RESOURCES_URL = window.uisettings.resourcesEndpoint;
const BASE_SEARCH_URL = window.uisettings.searchEndpoint;
const BASE_REPORTS_URL = window.uisettings.reportsEndpoint;

export function getHttpClient() {
    return getClientInternal(BASE_URL);
}

export function getResourcesHttpClient() {
    return getClientInternal(BASE_RESOURCES_URL);
}

export function getReportsHttpClient() {
    return getClientInternal(BASE_REPORTS_URL);
}

export function getSearchHttpClient() {
    return getClientInternal(BASE_SEARCH_URL);
}

function getClientInternal(baseUrl) {
    var client = axios.create({
        baseURL: baseUrl,
        timeout: 15000,
        headers: {}
    });

    client.interceptors.request.use(
        function(config) {
            return getAccessTokenSilent().then(result => {
                config.headers["Authorization"] = `Bearer ${result.accessToken}`;
                return Promise.resolve(config)
            })
            // // always grab the latest !
            // config.headers["Authorization"] = `Bearer ${getAccessToken()}`;
            // // always grab the latest team!
            // if (team) {
            //     config.headers["x-fdback-context"] = team;
            // }
            // return config;
        },
        function(error) {
            console.log(error);
            return Promise.reject(error);
        }
    );

    return client;
}