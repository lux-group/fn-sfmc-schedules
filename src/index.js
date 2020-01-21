console.log('Loading function');
// this is a test, does this appear

exports.handler = async (event, context) => {
  console.log('Received event:', JSON.stringify(event, null, 2));
}
