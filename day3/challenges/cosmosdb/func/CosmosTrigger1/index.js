module.exports = async function (context, documents) {
  if (!!documents && documents.length > 0) {
    let out = []
    documents.forEach((val) => {
      if (
        val.type == 'customer' &&
        val.addresses != undefined &&
        val.addresses != null &&
        val.addresses.length > 0 &&
        val.addresses[0].country != undefined &&
        val.addresses[0].country != null &&
        (val.addresses[0].country == 'DE' || val.addresses[0].country == 'FR') // just use 'DE' and 'FR' to limit processing time
      ) {
        out.push({
          id: val.id,
          area: val.addresses[0].country,
          title: val.title,
          firstName: val.firstName,
          lastName: val.lastName,
          emailAddress: val.emailAddress,
          phoneNumber: val.phoneNumber,
          addresses: val.addresses,
          salesOrderCount: val.salesOrderCount,
        })
      }
    })

    context.log('Processed input documents: ', documents.length)

    if (out.length > 0) {
      context.bindings.custDocs = JSON.stringify(out)
    }
  }
}
