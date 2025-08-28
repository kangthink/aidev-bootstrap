---
name: skill-analyze-arch-in-dsl
description: "Analyze the architecture of a project in DSL"
tools: [
    "Bash(tree:*)",
    "Python(pydoc:*)",
    "Bash(man:*)",
]
---

# Skill: Analyze Architecture in DSL

## Process
- Detect the project main language and entrypoint of the project
- Scan Files and Directories using `tree` to find the project architecture
- Use proper tools to read the code compactly
    - `python -m pydoc <module>` (if the module is a python module and python is installed)
    - `man <command>` (if the command is a bash command and bash is installed) 
- Output the DSL in a structured format


## Format Example

```dsl
component Payments {
    responsibility: "Handle the payment approval for an order"
    inbound {
        event OrderCreated(OrderId, Amount) -> PaymentId
    }
    outbound {
        port PSP_A { Charge(Amount) -> Result }
    }
    policies {
        reliability { timeout: 200ms, retry: exp(3) }
        idempotency { key: orderId }
        consistency { model: eventual }
    }
    state {
        entity Payment { id: UUID, status: Enum(Pending, Approved, Declined) }
        invariant "amount >= 0"
    }
    observability {
        logs { fields: [order_id, payment_id, status, outcome, latency] }
        metrics { rate, errors, duration, kpi: approval_success_rate }
    }
    failure {
        psp_a_timeout -> enqueue PendingApprovals
    }
}
```