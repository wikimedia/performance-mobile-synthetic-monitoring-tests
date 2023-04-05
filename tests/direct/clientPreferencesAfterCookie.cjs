const factory = require( './includes/clientPreferencesFactory.cjs' );
const PREF_COUNT = 100;

module.exports = factory(
	'Test after multiple client preferences stored in a cookie',
	'Disable 100 client preferences via mwclientprefs cookie, then visit static United_States page',
	"/speed-tests/United_States.enwiki.1146952659/after-multiple-cookie-values/",
	async (commands) => {
		// Add 100 values to mwclientprefs cookie.
		await commands.js.run( `
			let prefs = [];
			for (var i = 0; i < ${PREF_COUNT}; i++) {
					prefs.push(\`feature-\${i}\`);
			}
			mw.cookie.set('mwclientprefs', prefs.join('|'));
		`);
	}
);
