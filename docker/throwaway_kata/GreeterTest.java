// The test half of the workload the AOT caches are recorded from. It verifies
// through Approvals rather than an assertion, which is what pulls the approval
// machinery (the comparator and the file naming) into the cache alongside
// JUnit's own classes.
//
// The reporter is not among them, and cannot be: a reporter runs only when an
// approval does not match, and this one matches. Recording from a kata that
// fails instead puts the reporter's classes in the cache and makes no
// measurable difference to a failing run, the cost there being the reporter's
// own work rather than the loading of it.
//
// It passes, because a JVM writes a cache when it exits of its own accord and a
// green run is the simplest way to be sure of that. The .approved.txt file
// beside this one is what makes it pass.
import org.junit.jupiter.api.Test;
import org.approvaltests.Approvals;

public class GreeterTest {

    @Test
    public void records_its_greeting() {
        Approvals.verify(new Greeter().greeting());
    }
}
