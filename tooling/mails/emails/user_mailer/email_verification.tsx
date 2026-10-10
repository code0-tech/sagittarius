import type { CSSProperties } from "react"
import { Body, Button, Column, Container, Head, Heading, Html, Img, Link, Preview, Row, Section, Text } from "react-email"
import messages from "../../messgages/en.json"
import { colors } from "../theme"

interface EmailVerificationProps {
    companyName: string
    verificationUrl: string
    userName: string
    accountName: string
    email: string
    linkExpiresIn: string
    supportEmail: string
    logoUrl: string
}

export const EmailVerification = ({
    companyName = "<%= @company_name %>",
    verificationUrl = "<%= @verification_url %>",
    userName = "<%= @user_name %>",
    accountName = "<%= @account_name %>",
    email = "<%= @email %>",
    linkExpiresIn = "<%= @link_expires_in %>",
    supportEmail = "<%= @support_email %>",
    logoUrl = "<%= @logo_url %>",
}: EmailVerificationProps) => {
    const content = messages.emailVerification

    return (
        <Html lang="en">
            <Head />
            <Preview>{interpolate(content.preview, { companyName })}</Preview>

            <Body style={body}>
                <Container style={container}>
                    <Section style={card}>
                        <Section style={statusIcon}>
                            <Text style={statusMark}>✉</Text>
                        </Section>

                        <Heading as="h1" style={heading}>
                            {content.heading}
                        </Heading>

                        <Text style={intro}>
                            {interpolate(content.greeting, { userName })}
                            <br />
                            <br />
                            {interpolate(content.explanation, { companyName, email })}
                        </Text>

                        <Section style={summary}>
                            <Row style={summaryRow}>
                                <Column style={labelColumn}>
                                    <Text style={label}>{content.labels.account}</Text>
                                </Column>
                                <Column style={valueColumn}>
                                    <Text style={value}>{accountName}</Text>
                                </Column>
                            </Row>

                            <Row style={summaryRow}>
                                <Column style={labelColumn}>
                                    <Text style={label}>{content.labels.email}</Text>
                                </Column>
                                <Column style={valueColumn}>
                                    <Text style={value}>{email}</Text>
                                </Column>
                            </Row>

                            <Row>
                                <Column style={labelColumn}>
                                    <Text style={label}>{content.labels.linkExpires}</Text>
                                </Column>
                                <Column style={valueColumn}>
                                    <Text style={highlightedValue}>{linkExpiresIn}</Text>
                                </Column>
                            </Row>
                        </Section>

                        <Section style={buttonSection}>
                            <Button href={verificationUrl} style={button}>
                                {content.actions.verifyEmail}
                            </Button>
                        </Section>

                        <Text style={fallback}>
                            {content.fallback.beforeLink}
                            <br />
                            <Link href={verificationUrl} style={fallbackLink}>
                                {verificationUrl}
                            </Link>
                        </Text>

                        <Text style={notice}>{content.notice}</Text>

                        <Text style={help}>
                            {content.support.beforeEmail}{" "}
                            <Link href={`mailto:${supportEmail}`} style={link}>
                                {supportEmail}
                            </Link>
                            {content.support.afterEmail}
                        </Text>
                    </Section>

                    <Section style={logoSection}>
                        <Img src={logoUrl} alt={`${companyName} logo`} width={160} height={39} style={logo} />
                    </Section>

                    <Section style={footer}>
                        <Text style={footerText}>
                            {interpolate(content.footer.transactionalNotice, { companyName, email })}
                            <br />© {new Date().getFullYear()} {companyName}
                        </Text>
                    </Section>
                </Container>
            </Body>
        </Html>
    )
}

EmailVerification.PreviewProps = {
    companyName: "CodeZero",
    verificationUrl: "https://codezero.build/verify?code=eyJfcmFpbHMiOnsiZGF0YSI6WzEsIm5vcmVwbHlAY29kZTAudGVjaCJdfX0",
    userName: "nsammito",
    accountName: "Nico Sammito",
    email: "root@code0.tech",
    linkExpiresIn: "15 minutes",
    supportEmail: "support@code0.tech",
    logoUrl: "https://codezero.build/api/media/file/Logo-03%20copy-cropped%20copy.svg",
} satisfies EmailVerificationProps

export default EmailVerification

const interpolate = (message: string, values: Record<string, string>) =>
    Object.entries(values).reduce((result, [key, value]) => result.split(`{{${key}}}`).join(value), message)

const body: CSSProperties = {
    backgroundColor: colors.background,
    color: colors.white,
    fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
    margin: 0,
    padding: "32px 12px",
}

const container: CSSProperties = {
    margin: "0 auto",
    maxWidth: "600px",
    width: "100%",
}

const card: CSSProperties = {
    backgroundColor: colors.surface,
    border: `1px solid ${colors.border}`,
    borderRadius: "24px",
    padding: "48px 40px",
    textAlign: "center",
}

const statusIcon: CSSProperties = {
    backgroundColor: colors.brandBackground,
    borderRadius: "16px",
    height: "48px",
    margin: "0 auto 20px",
    width: "48px",
}

const statusMark: CSSProperties = {
    color: colors.brand,
    fontSize: "24px",
    fontWeight: 700,
    lineHeight: "48px",
    margin: 0,
    textAlign: "center",
}

const heading: CSSProperties = {
    color: colors.white,
    fontSize: "28px",
    fontWeight: 700,
    letterSpacing: "-0.5px",
    lineHeight: "36px",
    margin: "0 0 20px",
}

const intro: CSSProperties = {
    color: colors.secondary,
    fontSize: "16px",
    lineHeight: "25px",
    margin: "0 auto 32px",
    maxWidth: "460px",
    textAlign: "left",
}

const summary: CSSProperties = {
    backgroundColor: colors.background,
    border: `1px solid ${colors.border}`,
    borderRadius: "24px",
    padding: "8px 20px",
}

const summaryRow: CSSProperties = {
    borderBottom: `1px solid ${colors.border}`,
}

const labelColumn: CSSProperties = {
    padding: "12px 0",
    textAlign: "left",
    verticalAlign: "middle",
    width: "45%",
}

const valueColumn: CSSProperties = {
    padding: "12px 0",
    textAlign: "right",
    verticalAlign: "middle",
    width: "55%",
}

const label: CSSProperties = {
    color: colors.tertiary,
    fontSize: "14px",
    lineHeight: "20px",
    margin: 0,
}

const value: CSSProperties = {
    color: colors.white,
    fontSize: "14px",
    fontWeight: 600,
    lineHeight: "20px",
    margin: 0,
}

const highlightedValue: CSSProperties = {
    ...value,
    color: colors.brand,
}

const buttonSection: CSSProperties = {
    margin: "32px 0 0",
}

const button: CSSProperties = {
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

const fallback: CSSProperties = {
    color: colors.tertiary,
    fontSize: "12px",
    lineHeight: "19px",
    margin: "24px auto 0",
    maxWidth: "460px",
    wordBreak: "break-all",
}

const fallbackLink: CSSProperties = {
    color: colors.secondary,
    textDecoration: "underline",
}

const notice: CSSProperties = {
    color: colors.secondary,
    fontSize: "13px",
    lineHeight: "20px",
    margin: "24px auto 0",
    maxWidth: "460px",
}

const help: CSSProperties = {
    color: colors.tertiary,
    fontSize: "13px",
    lineHeight: "20px",
    margin: "16px auto 0",
    maxWidth: "420px",
}

const link: CSSProperties = {
    color: colors.brand,
    textDecoration: "underline",
}

const logoSection: CSSProperties = {
    padding: "28px 16px 0",
    textAlign: "center",
}

const logo: CSSProperties = {
    display: "block",
    height: "39px",
    margin: "0 auto",
    width: "160px",
}

const footer: CSSProperties = {
    padding: "24px 16px 0",
}

const footerText: CSSProperties = {
    color: colors.tertiary,
    fontSize: "12px",
    lineHeight: "19px",
    margin: 0,
    textAlign: "center",
}
