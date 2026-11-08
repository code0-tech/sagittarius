/**
 * The shared card layout every transactional email is built from: dark page, one rounded card,
 * a status icon, a summary table of label/value rows, a button, and the logo/footer below.
 *
 * `theme.ts` holds the colors; this holds the geometry. Templates only define what is actually
 * their own (and pick a `statusIcon`/`statusMark` accent), so a layout fix lands in every mail
 * instead of in one of them.
 *
 * Plain objects on purpose: these are inlined as `style` attributes by react-email, since email
 * clients cannot be relied on for anything else (see the note on colors in `theme.ts`).
 */
import type { CSSProperties } from "react"
import { colors, type EmailColor } from "./theme"

export const body: CSSProperties = {
    backgroundColor: colors.background,
    color: colors.white,
    fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
    margin: 0,
    padding: "32px 12px",
}

export const container: CSSProperties = {
    margin: "0 auto",
    maxWidth: "600px",
    width: "100%",
}

export const card: CSSProperties = {
    backgroundColor: colors.surface,
    border: `1px solid ${colors.border}`,
    borderRadius: "24px",
    padding: "48px 40px",
    textAlign: "center",
}

/** The circle the status glyph sits in, tinted to the accent the mail is about. */
export const statusIcon = (background: EmailColor): CSSProperties => ({
    backgroundColor: colors[background],
    borderRadius: "16px",
    height: "48px",
    margin: "0 auto 20px",
    width: "48px",
})

export const statusMark = (color: EmailColor): CSSProperties => ({
    color: colors[color],
    fontSize: "24px",
    fontWeight: 700,
    lineHeight: "48px",
    margin: 0,
    textAlign: "center",
})

export const heading: CSSProperties = {
    color: colors.white,
    fontSize: "28px",
    fontWeight: 700,
    letterSpacing: "-0.5px",
    lineHeight: "36px",
    margin: "0 0 20px",
}

export const intro: CSSProperties = {
    color: colors.secondary,
    fontSize: "16px",
    lineHeight: "25px",
    margin: "0 auto 32px",
    maxWidth: "460px",
    textAlign: "left",
}

export const summary: CSSProperties = {
    backgroundColor: colors.background,
    border: `1px solid ${colors.border}`,
    borderRadius: "24px",
    padding: "8px 20px",
}

/** Every summary row but the last one, which carries no divider. */
export const summaryRow: CSSProperties = {
    borderBottom: `1px solid ${colors.border}`,
}

export const labelColumn: CSSProperties = {
    padding: "12px 0",
    textAlign: "left",
    verticalAlign: "middle",
    width: "45%",
}

export const valueColumn: CSSProperties = {
    padding: "12px 0",
    textAlign: "right",
    verticalAlign: "middle",
    width: "55%",
}

export const label: CSSProperties = {
    color: colors.tertiary,
    fontSize: "14px",
    lineHeight: "20px",
    margin: 0,
}

export const value: CSSProperties = {
    color: colors.white,
    fontSize: "14px",
    fontWeight: 600,
    lineHeight: "20px",
    margin: 0,
}

/** A summary value worth pulling the eye to, in the accent the mail is about. */
export const highlightedValue = (color: EmailColor): CSSProperties => ({
    ...value,
    color: colors[color],
})

export const buttonSection: CSSProperties = {
    margin: "32px 0 0",
}

export const button: CSSProperties = {
    backgroundColor: colors.white,
    borderRadius: "16px",
    color: colors.background,
    display: "inline-block",
    fontSize: "16px",
    fontWeight: 600,
    lineHeight: "24px",
    padding: "12px 24px",
    textDecoration: "none",
}

export const notice: CSSProperties = {
    color: colors.secondary,
    fontSize: "13px",
    lineHeight: "20px",
    margin: "24px auto 0",
    maxWidth: "460px",
}

export const help: CSSProperties = {
    color: colors.tertiary,
    fontSize: "13px",
    lineHeight: "20px",
    margin: "16px auto 0",
    maxWidth: "420px",
}

export const link = (color: EmailColor): CSSProperties => ({
    color: colors[color],
    textDecoration: "underline",
})

export const logoSection: CSSProperties = {
    padding: "28px 16px 0",
    textAlign: "center",
}

export const logo: CSSProperties = {
    display: "block",
    height: "32px",
    margin: "0 auto",
    width: "160px",
}

export const footer: CSSProperties = {
    padding: "24px 16px 0",
}

export const footerText: CSSProperties = {
    color: colors.tertiary,
    fontSize: "12px",
    lineHeight: "19px",
    margin: 0,
    textAlign: "center",
}

/** The logo image every mail closes with. */
export const LOGO_URL = "https://codezero.build/api/media/file/CodeZero_Logo.png"

/** Fills `{{placeholder}}`s in a message with values. */
export const interpolate = (message: string, values: Record<string, string>) =>
    Object.entries(values).reduce((result, [key, value]) => result.split(`{{${key}}}`).join(value), message)
