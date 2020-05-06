import axios from "axios";
const BASE_URL = window.uisettings.endpoint;
const BASE_RESOURCES_URL = window.uisettings.resourcesEndpoint;
const BASE_SEARCH_URL = window.uisettings.searchEndpoint;
const BASE_REPORTS_URL = window.uisettings.reportsEndpoint;

export function getHttpClient(token) {
    return getClientInternal(BASE_URL, token);
}

export function getResourcesHttpClient(token) {
    return getClientInternal(BASE_RESOURCES_URL, token);
}

export function getReportsHttpClient(token) {
    return getClientInternal(BASE_REPORTS_URL, token);
}

export function getSearchHttpClient(token) {
    return getClientInternal(BASE_SEARCH_URL, token);
}

function getClientInternal(baseUrl, token) {
    var client = axios.create({
        baseURL: baseUrl,
        timeout: 15000,
        headers: {
            'Authorization': `Bearer ${token}`
        }
    });

    return client;
}