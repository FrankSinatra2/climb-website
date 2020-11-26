// Initial data passed to Elm (should match `Flags` defined in `Shared.elm`)
// https://guide.elm-lang.org/interop/flags.html
let flags = {
    access_token: JSON.parse(localStorage.getItem('access_token')) || null
}

// Start our Elm application
let app = Elm.Main.init({ flags: flags })

// Ports go here
// https://guide.elm-lang.org/interop/ports.html
app.ports.outgoing.subscribe(({tag, data}) => {
    switch (tag) {
        case 'saveAccessToken':
            return localStorage.setItem('access_token', JSON.stringify(data));

        case 'clearAccessToken':
            return localStorage.removeItem('access_token');
            
        default:
            return console.warn('Unrecognized Elm-Port', tag);
    };
});
