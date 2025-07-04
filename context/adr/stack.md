# Stack

## Status

Accepted

## Context

It is useful for an web app to be based on a certain stack with wellknown components.

The components of the stack should have an active community, accessible documentation, and an ecosystem of components and libraries

## Decision

- The frontend should be based on latest stable release of SvelteKit, supporting Svelte 5 and runes
- The frontend should use latest stable releases of DaisyUI and Tailwind for components and theming
- The frontend should be deployed on Cloudflare Pages
- The backend API should be according to SvelteKit standards
- The Backend should use Cloudflare D1 (SQLite) ad database and Cloudflare KV for configuration stuff

## Consequences

We can use tooling designed for the components of the stack, and with acceptable DX.

## Urls

- [SvelteKit Documentation](https://kit.svelte.dev/)
- [Svelte 5 Documentation](https://svelte.dev/docs/svelte/overview)
- [Svelte 5 Runes](https://svelte.dev/docs/svelte/what-are-runes)
- [DaisyUI Documentation](https://daisyui.com/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Cloudflare Pages Documentation](https://developers.cloudflare.com/pages/)
- [Cloudflare D1 Documentation](https://developers.cloudflare.com/d1/)
- [Cloudflare KV Documentation](https://developers.cloudflare.com/kv/)