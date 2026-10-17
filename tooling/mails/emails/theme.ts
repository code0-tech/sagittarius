/**
 * Shared color palette for all transactional emails.
 *
 * Keep colors semantic so templates describe where a color is used instead
 * of depending on a specific shade. This also makes future brand changes
 * possible in one place.
 */
export const colors = {
    background: "oklch(0.1298 0.0346 288.38)",
    surface: "oklch(0.2166 0.0253 287.61)",
    border: "oklch(0.2438 0.0265 290.84)",

    white: "oklch(1 0 0)",
    secondary: "oklch(0.781 0.03 292.73)",
    tertiary: "oklch(0.674 0.017 292.6)",

    brand: "oklch(0.9018 0.165 157.04)",
    brandBackground: "oklch(0.295 0.019 218.63)",

    success: "oklch(0.7015 0.2286 141.65)",
    successBackground: "oklch(0.2659 0.0222 166.39)",

    warning: "oklch(0.8385 0.1709 83.34)",
    warningBackground: "oklch(0.2863 0.0162 67.11)",

    error: "oklch(0.5591 0.2248 23.97)",
    errorBackground: "oklch(0.2372 0.0432 339.92)",
} as const

export type EmailColor = keyof typeof colors
