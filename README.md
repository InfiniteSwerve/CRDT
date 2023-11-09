# Conflict Free Replicated Data Types
## Idea
Systems that adopt a weak consistency model allow replicas to temporarily diverge, requiring a mechanism for merging concurrent updates into a common state. Conflict-free Replicated Data Types (CRDT) provide a principled approach to address this problem.
Abstract data type with a well-defined interface and two key properties:
1. Any replica can be modified without coordination
2. When two replicas have the same set of updates they reach the same state

### Happens-before
e1 happened-before e2 (e1 < u2) iff: 
1. e1 occurred before e2 in the same process (locally?)
2. e1 is the event of sending message m, and e2 is the event of receiving that message
3. there exists e such that e1 < e, e < e2

## Questions
What are the transition rules
- Depends on the data/state machine
Is there a limit to the kinds of data we can use there?
- No, so long as we provide reconciliation rules
## Sources
https://lamport.azurewebsites.net/pubs/time-clocks.pdf
https://arxiv.org/pdf/1806.10254.pdf
https://en.wikipedia.org/wiki/Conflict-free_replicated_data_type
https://crdt.tech/papers.html
