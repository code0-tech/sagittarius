import { Body, Button, Column, Container, Head, Heading, Html, Img, Link, Preview, Row, Section, Text } from "react-email"
import messages from "../../../../messgages/en.json"
import * as s from "../../../styles"

/**
 * Sent after a license is deleted. Every value is a snapshot the mailer was handed - the license
 * row is gone by the time this renders (see Licenses::NotifyRemovalService).
 */
interface LicenseRemovedProps {
    companyName: string
    legalName: string
    userName: string
    accountName: string
    licensee: string
    plan: string
    licensePeriod: string
    removedAt: string
    dashboardUrl: string
    email: string
    supportEmail: string
}

export const LicenseRemoved = ({
    companyName = "<%= @company_name %>",
    legalName = "<%= @legal_name %>",
    userName = "<%= @user_name %>",
    accountName = "<%= @account_name %>",
    licensee = "<%= @licensee %>",
    plan = "<%= @plan %>",
    licensePeriod = "<%= @license_period %>",
    removedAt = "<%= @removed_at %>",
    dashboardUrl = "<%= @dashboard_url %>",
    email = "<%= @email %>",
    supportEmail = "<%= @support_email %>",
}: LicenseRemovedProps) => {
    const content = messages.licenseRemoved

    return (
        <Html lang="en">
            <Head />
            <Preview>{s.interpolate(content.preview, { companyName })}</Preview>

            <Body style={s.body}>
                <Container style={s.container}>
                    <Section style={s.card}>
                        <Section style={s.statusIcon("errorBackground")}>
                            <Text style={s.statusMark("error")}>⊘</Text>
                        </Section>

                        <Heading as="h1" style={s.heading}>
                            {content.heading}
                        </Heading>

                        <Text style={s.intro}>
                            {s.interpolate(content.greeting, { userName })}
                            <br />
                            <br />
                            {content.explanation}
                        </Text>

                        <Section style={s.summary}>
                            <Row style={s.summaryRow}>
                                <Column style={s.labelColumn}>
                                    <Text style={s.label}>{content.labels.account}</Text>
                                </Column>
                                <Column style={s.valueColumn}>
                                    <Text style={s.value}>{accountName}</Text>
                                </Column>
                            </Row>

                            <Row style={s.summaryRow}>
                                <Column style={s.labelColumn}>
                                    <Text style={s.label}>{content.labels.licensee}</Text>
                                </Column>
                                <Column style={s.valueColumn}>
                                    <Text style={s.value}>{licensee}</Text>
                                </Column>
                            </Row>

                            <Row style={s.summaryRow}>
                                <Column style={s.labelColumn}>
                                    <Text style={s.label}>{content.labels.plan}</Text>
                                </Column>
                                <Column style={s.valueColumn}>
                                    <Text style={s.value}>{plan}</Text>
                                </Column>
                            </Row>

                            <Row style={s.summaryRow}>
                                <Column style={s.labelColumn}>
                                    <Text style={s.label}>{content.labels.period}</Text>
                                </Column>
                                <Column style={s.valueColumn}>
                                    <Text style={s.value}>{licensePeriod}</Text>
                                </Column>
                            </Row>

                            <Row>
                                <Column style={s.labelColumn}>
                                    <Text style={s.label}>{content.labels.removedOn}</Text>
                                </Column>
                                <Column style={s.valueColumn}>
                                    <Text style={s.highlightedValue("error")}>{removedAt}</Text>
                                </Column>
                            </Row>
                        </Section>

                        <Section style={s.buttonSection}>
                            <Button href={dashboardUrl} style={s.button}>
                                {content.actions.openDashboard}
                            </Button>
                        </Section>

                        <Text style={s.notice}>{content.notice}</Text>

                        <Text style={s.help}>
                            {content.support.beforeEmail}{" "}
                            <Link href={`mailto:${supportEmail}`} style={s.link("error")}>
                                {supportEmail}
                            </Link>
                            {content.support.afterEmail}
                        </Text>
                    </Section>

                    <Section style={s.logoSection}>
                        <Img src={s.LOGO_URL} alt={`${companyName} logo`} width={160} height={32} style={s.logo} />
                    </Section>

                    <Section style={s.footer}>
                        <Text style={s.footerText}>
                            {s.interpolate(content.footer.transactionalNotice, { companyName, email })}
                            <br />© {new Date().getFullYear()} {legalName}
                        </Text>
                    </Section>
                </Container>
            </Body>
        </Html>
    )
}

LicenseRemoved.PreviewProps = {
    companyName: "CodeZero",
    legalName: "Code0 UG (haftungsbeschränkt)",
    userName: "nsammito",
    accountName: "nsammito",
    licensee: "Code0",
    plan: "PRO",
    licensePeriod: "January 15, 2026 - January 14, 2027",
    removedAt: "November 8, 2026",
    dashboardUrl: "https://codezero.build",
    email: "root@code0.tech",
    supportEmail: "support@codezero.build",
} satisfies LicenseRemovedProps

export default LicenseRemoved
