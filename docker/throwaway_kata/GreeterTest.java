// The test half of the workload the AOT caches are recorded from. It verifies
// through Approvals rather than an assertion, which is what pulls the approval
// machinery -- the comparator, the reporter and the file naming -- into the
// cache alongside JUnit's own classes.
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
