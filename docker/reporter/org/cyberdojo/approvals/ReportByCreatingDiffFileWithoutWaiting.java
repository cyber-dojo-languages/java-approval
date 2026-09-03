package org.cyberdojo.approvals;

import org.approvaltests.reporters.linux.ReportByCreatingDiffFile;

// Writes the same .diff file as the reporter it extends, without the wait.
//
// ApprovalTests launches a diff program and then sleeps for 800 milliseconds
// before returning, which gives a diff program with a window of its own time to
// appear before the JVM exits and takes it down. The diff program here is
// /usr/bin/diff, which writes to its output and exits, so there is no window to
// wait for and the sleep is 800 milliseconds of a kata's [test] press spent
// waiting for nothing. Every failing press pays it, and a kata is failing most
// of the time it is being worked on.
//
// Only the waiting is left out. Which program to run, what to call the .diff
// file and what to write into it stay where they were, so this keeps reporting
// whatever the library reports and there is one place to change if that moves.
public class ReportByCreatingDiffFileWithoutWaiting extends ReportByCreatingDiffFile {

    public static final ReportByCreatingDiffFileWithoutWaiting INSTANCE =
        new ReportByCreatingDiffFileWithoutWaiting();

    @Override
    public boolean launch(String received, String approved) {
        try {
            ProcessBuilder builder = new ProcessBuilder(getCommandLine(received, approved));
            preventProcessFromClosing(builder);
            Process process = builder.start();
            // Reads the diff program's output into the .diff file, which is what
            // the superclass does with it.
            processOutput(received, process);
            // Waiting for the program to finish is not the same as sleeping for
            // a fixed time: it returns as soon as the diff has been written.
            process.waitFor();
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
