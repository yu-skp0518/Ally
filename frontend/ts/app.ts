/**
 * Ally frontend - TypeScript entry
 * Build: npm run build
 */

export function initAlly(): void {
  document.querySelectorAll('[data-ally-search]').forEach((el) => {
    el.addEventListener('submit', (e: Event) => {
      const form = e.target as HTMLFormElement;
      const keyword = (form.querySelector('[name="keyword"]') as HTMLInputElement)?.value?.trim();
      if (!keyword) {
        e.preventDefault();
      }
    });
  });
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => initAlly());
} else {
  initAlly();
}
