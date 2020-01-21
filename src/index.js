console.log('Loading function');
// this is a test, does this appear

const handler = async (event, context) => {
  console.log('Received event:', JSON.stringify(event, null, 2));
}

handler(event, context)
