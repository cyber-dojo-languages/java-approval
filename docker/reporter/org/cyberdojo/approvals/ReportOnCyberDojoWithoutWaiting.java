package org.cyberdojo.approvals;

import org.approvaltests.reporters.JunitReporter;
import org.approvaltests.reporters.MultiReporter;

// Reports a failing approval the way ApprovalTests' own ReportOnCyberDojo does,
// pairing the .diff file with the message JUnit prints, and this is the class a
// kata names. The difference is the reporter it pairs, which does not wait 800
// milliseconds for a window that never opens. See
// ReportByCreatingDiffFileWithoutWaiting.
public class ReportOnCyberDojoWithoutWaiting extends MultiReporter {

    public static final ReportOnCyberDojoWithoutWaiting INSTANCE =
        new ReportOnCyberDojoWithoutWaiting();

    public ReportOnCyberDojoWithoutWaiting() {
        super(ReportByCreatingDiffFileWithoutWaiting.INSTANCE, JunitReporter.INSTANCE);
    }
}
