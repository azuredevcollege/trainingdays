import axios from "axios";
const BASE_URL = window.uisettings.endpoint;
const BASE_RESOURCES_URL = window.uisettings.resourcesEndpoint;

export function getHttpClient() {
    return getClientInternal(BASE_URL);
}

export function getResourcesHttpClient() {
    return getClientInternal(BASE_RESOURCES_URL);
}

function getClientInternal(baseUrl) {
    var client = axios.create({
        baseURL: baseUrl,
        timeout: 15000,
    });

    return client;
}