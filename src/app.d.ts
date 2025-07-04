// See https://kit.svelte.dev/docs/types#app
// for information about these interfaces
/// <reference types="@cloudflare/workers-types" />

declare global {
  namespace App {
    // interface Error {}
    // interface Locals {}
    // interface PageData {}
    // interface PageState {}
    interface Platform {
      env: {
        DB: D1Database;
        KV: KVNamespace;
        ANALYTICS?: AnalyticsEngineDataset;
      };
      context: {
        waitUntil(promise: Promise<unknown>): void;
      };
      caches: CacheStorage & { default: Cache };
    }
  }
}

export {};
