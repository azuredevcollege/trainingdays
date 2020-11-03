import axios from "axios";
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
    });

    return client;
}