console.log('Loading function');

const handler = async (event, context) => {
  console.log('Received event:', JSON.stringify(event, null, 2));
}

handler(event, context)
