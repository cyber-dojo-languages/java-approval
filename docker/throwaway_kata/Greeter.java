// Part of the workload the AOT caches are recorded from. It has to exist before
// any learner's kata does, so what the caches hold are the compiler's classes,
// JUnit's and ApprovalTests' rather than any kata's, and they speed up whatever
// a learner writes.
public class Greeter {

    public String greeting() {
        return "hello";
    }
}
