/**
 * Shared color palette for all transactional emails.
 *
 * Keep colors semantic so templates describe where a color is used instead
 * of depending on a specific shade. This also makes future brand changes
 * possible in one place.
 *
 * Colors are hex on purpose. Outlook on Windows renders with the Word engine,
 * which does not know `oklch()` — or any other modern color function — and
 * drops the whole declaration instead of approximating it. A dropped
 * `background-color`/`color` falls back to the client default, so a dark
 * template would arrive black-on-white there.
 */
export const colors = {
    background: "#070514",
    surface: "#191825",
    border: "#201e2c",

    white: "#ffffff",
    secondary: "#b8b5ca",
    tertiary: "#9695a0",

    brand: "#70ffb2",
    brandBackground: "#222f33",

    success: "#29bf12",
    successBackground: "#1b2923",

    warning: "#ffbe0b",
    warningBackground: "#302922",

    error: "#d90429",
    errorBackground: "#2c1625",
} as const

export type EmailColor = keyof typeof colors
