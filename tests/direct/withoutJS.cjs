module.exports = async function ( context, commands ) {
  const cdpClient = commands.cdp.getRawClient();
  await cdpClient.Fetch.enable({
    handleAuthRequests: false,
    patterns: [
      {
        urlPattern: '*',
        resourceType: 'Document',
        requestStage: 'Response'
      }
    ]
  });

  cdpClient.Fetch.requestPaused(async reqEvent => {
    const { requestId, resourceType } = reqEvent;

    const myBody = await cdpClient.Fetch.getResponseBody({
      requestId
    });

    let text = Buffer.from(myBody.body, 'base64').toString('utf8');

    let rlmodules = text.substring(
      text.lastIndexOf('RLPAGEMODULES'),
      text.lastIndexOf('];') + 2
    );
    text = text.replaceAll(rlmodules, 'RLPAGEMODULES=["ext.eventLogging"];');
    return cdpClient.Fetch.fulfillRequest({
      requestId,
      responseCode: 200,
      body: Buffer.from(text, 'utf8').toString('base64')
    });
  });

  await commands.measure.start('barackWithoutJS');
  await commands.navigate('https://en.m.wikipedia.org/wiki/Barack_Obama');
  // await commands.scroll.toBottom();
  await commands.click.byId('mw-mf-main-menu-button');
  await commands.wait.byTime(2000);
  return commands.measure.stop();
}
