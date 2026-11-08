import { Body, Button, Column, Container, Head, Heading, Html, Img, Link, Preview, Row, Section, Text } from "react-email"
import messages from "../../messgages/en.json"
import * as s from "../styles"

/**
 * The heads-up sent once a metered resource crosses its warning threshold. Same shape as
 * `limit_reached`, but nothing is blocked yet - so it is tinted as a warning and names the
 * share used rather than declaring the budget gone.
 */
interface UsageLimitWarningProps {
    companyName: string
    legalName: string
    userName: string
    accountName: string
    affectedResources: string
    thresholdPercentage: string
    aiUsageSummary: string
    workflowUsageSummary: string
    resetDate: string
    dashboardUrl: string
    email: string
    supportEmail: string
}

export const UsageLimitWarning = ({
    companyName = "<%= @company_name %>",
    legalName = "<%= @legal_name %>",
    userName = "<%= @user_name %>",
    accountName = "<%= @account_name %>",
    affectedResources = "<%= @affected_resources %>",
    thresholdPercentage = "<%= @threshold_percentage %>",
    aiUsageSummary = "<%= @ai_usage_summary %>",
    workflowUsageSummary = "<%= @workflow_usage_summary %>",
    resetDate = "<%= @reset_date %>",
    dashboardUrl = "<%= @dashboard_url %>",
    email = "<%= @email %>",
    supportEmail = "<%= @support_email %>",
}: UsageLimitWarningProps) => {
    const content = messages.usageLimitWarning

    return (
        <Html lang="en">
            <Head />
            <Preview>{s.interpolate(content.preview, { thresholdPercentage, affectedResources })}</Preview>

            <Body style={s.body}>
                <Container style={s.container}>
                    <Section style={s.card}>
                        <Section style={s.statusIcon("warningBackground")}>
                            <Text style={s.statusMark("warning")}>▲</Text>
                        </Section>

                        <Heading as="h1" style={s.heading}>
                            {content.heading}
                        </Heading>

                        <Text style={s.intro}>
                            {s.interpolate(content.greeting, { userName })}
                            <br />
                            <br />
                            {s.interpolate(content.explanation, { thresholdPercentage, affectedResources })}
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
                                    <Text style={s.label}>{content.labels.aiTokens}</Text>
                                </Column>
                                <Column style={s.valueColumn}>
                                    <Text style={s.value}>{aiUsageSummary}</Text>
                                </Column>
                            </Row>

                            <Row style={s.summaryRow}>
                                <Column style={s.labelColumn}>
                                    <Text style={s.label}>{content.labels.workflowExecutions}</Text>
                                </Column>
                                <Column style={s.valueColumn}>
                                    <Text style={s.value}>{workflowUsageSummary}</Text>
                                </Column>
                            </Row>

                            <Row>
                                <Column style={s.labelColumn}>
                                    <Text style={s.label}>{content.labels.resets}</Text>
                                </Column>
                                <Column style={s.valueColumn}>
                                    <Text style={s.highlightedValue("warning")}>{resetDate}</Text>
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
                            <Link href={`mailto:${supportEmail}`} style={s.link("warning")}>
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

UsageLimitWarning.PreviewProps = {
    companyName: "CodeZero",
    legalName: "Code0 UG (haftungsbeschränkt)",
    userName: "nsammito",
    accountName: "nsammito",
    affectedResources: "AI tokens",
    thresholdPercentage: "80%",
    aiUsageSummary: "20,400 of 25,000 (82%)",
    workflowUsageSummary: "12 of 50 (24%)",
    resetDate: "January 15, 2027",
    dashboardUrl: "https://codezero.build",
    email: "root@code0.tech",
    supportEmail: "support@codezero.build",
} satisfies UsageLimitWarningProps

export default UsageLimitWarning
