const readReportsSchema = {
    operationId: 'readReports',
    params: {
        type: 'object',
        properties: {
            id: {
                type: 'string'
            }
        }
    },
    response: {
        200: {
            type: 'object',
            properties: {
                id: { type: 'string' },
                contact: {
                    type: 'object',
                    properties: {
                        id: { type: 'string' },
                        firstname: { type: 'string' },
                        lastname: { type: 'string' },
                        avatarLocation: { type: 'string' },
                        company: { type: 'string' }
                    }
                },
                subject: { type: 'string', maxLength: 255 },
                description: { type: 'string', maxLength: 1000 },
                result: { type: 'string', maxLength: 1000 },
                visitDate: {
                    type: 'string',
                    format: 'date'
                },
                detectedLanguage: { type: 'string' },
                visitResultSentimentScore: { type: 'number' },
                visitResultKeyPhrases: {
                    type: 'array',
                    items: {
                        type: 'string'
                    }
                }
            }
        }
    }
};

const deleteReportsSchema = {
    operationId: 'deletReports',
    params: {
        type: 'object',
        properties: {
            id: {
                type: 'string'
            }
        }
    }
};

const listReportsSchema = {
    operationId: 'listReports',
    querystring: {
        type: 'object',
        properties: {
            contactid: {
                type: 'string',
                default: ''
            }
        }
    },
    response: {
        200: {
            type: 'array',
            items: {
                type: 'object',
                properties: {
                    id: { type: 'string' },
                    contact: {
                        type: 'object',
                        properties: {
                            id: { type: 'string' },
                            firstname: { type: 'string' },
                            lastname: { type: 'string' },
                            avatarLocation: { type: 'string' },
                            company: { type: 'string' }
                        }
                    },
                    subject: { type: 'string', maxLength: 255 },
                    visitDate: {
                        type: 'string',
                        format: 'date'
                    }
                }
            }
        }
    }
};

const createReportsSchema = {
    operationId: 'createReports',
    body: {
        type: 'object',
        properties: {
            contact: {
                type: 'object',
                properties: {
                    id: { type: 'string' },
                    firstname: { type: 'string' },
                    lastname: { type: 'string' },
                    avatarLocation: { type: 'string' },
                    company: { type: 'string' }
                }
            },
            subject: { type: 'string', maxLength: 255 },
            description: { type: 'string', maxLength: 1000 },
            result: { type: 'string', maxLength: 1000 },
            visitDate: {
                type: 'string',
                format: 'date'
            }
        }
    }
};

const updateReportsSchema = {
    operationId: 'updateReports',
    params: {
        type: 'object',
        properties: {
            id: {
                type: 'string'
            }
        }
    },
    body: {
        type: 'object',
        properties: {
            id: { type: 'string' },
            contact: {
                type: 'object',
                properties: {
                    id: { type: 'string' },
                    firstname: { type: 'string' },
                    lastname: { type: 'string' },
                    avatarLocation: { type: 'string' },
                    company: { type: 'string' }
                }
            },
            subject: { type: 'string', maxLength: 255 },
            description: { type: 'string', maxLength: 1000 },
            result: { type: 'string', maxLength: 1000 },
            visitDate: {
                type: 'string',
                format: 'date'
            }
        }
    }
};

// Stats

const statsByContactSchema = {
    operationId: 'statsByContact',
    response: {
        200: {
            type: 'array',
            items: {
                type: 'object',
                properties: {
                    id: { type: 'string' },
                    countScore: { type: 'number' },
                    minScore: { type: 'number' },
                    maxScore: { type: 'number' },
                    avgScore: { type: 'number' }
                }
            }
        }
    }
};

const statsOverallSchema = {
    operationId: 'statsOverall',
    response: {
        200: {
            type: 'array',
            items: {
                type: 'object',
                properties: {
                    countScore: { type: 'number' },
                    minScore: { type: 'number' },
                    maxScore: { type: 'number' },
                    avgScore: { type: 'number' }
                }
            }
        }
    }
};

const statsTimelineSchema = {
    operationId: 'statsTimeline',
    response: {
        200: {
            type: 'array',
            items: {
                type: 'object',
                properties: {
                    visits: { type: 'number' },
                    visitDate: {
                        type: 'string',
                        format: 'date'
                    }
                }
            }
        }
    }
};

module.exports = {
    listReportsSchema,
    createReportsSchema,
    readReportsSchema,
    deleteReportsSchema,
    updateReportsSchema,
    statsByContactSchema,
    statsOverallSchema,
    statsTimelineSchema
}