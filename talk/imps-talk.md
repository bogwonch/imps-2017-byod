---
title: Common Concerns in BYOD Policies
author:
- Joseph Hallett --- School of Informatics, University of Edinburgh
theme:  metropolis
...

# BYOD Polices and MDM Software

- Bring Your Own Device
- Mobile Device Management

- How companies manage employee's devices at work

# BYOD Policies tend to be informal

- Natural language
- Variety of styles
- Relatively simple, but sometimes lengthy and with interesting relationships

# What we did

- Used a formal language to model 5 BYOD policies (SecPAL)
- Compared the contents looking for common concerns and structures
- How they contrast with MDM capabilities?

# What we found

- Diverse range of concerns
	- Not all of which are handled by MDM tooling
	
- In particular the *acknowledgement* of other rules, and *delegation*

# Five policies

- A SANS hypothetical policy
	- For companies looking to implement a BYOD policy
	- Prescriptive, and technically focussed

- An NHS Hosptial Trust policy
	- Longer, and with
	- Very concerned with patient privacy
	
- A HiMSS hyptothetical hopsital trust policy
	- Written as a contract
	- For hospitals looking to implement a BYOD policy
	
- Edinburgh University's policy
	- Very general and straightforward

- Emergency Siren manufacturer
	- Relatively simple
	
# SecPAL

- Authorization language designed for distributed access control decisions
- We have been using it to model privacy preferences
- Simple, highly readable grammar
- Intuitive and simple semantics

- We translate rules from the policy into SecPAL where possible

# SecPAL language #1

> Users MUST agree to the email security/acceptable use policy and eventually to the eCommerce security policy.

~~~~.secpal
'company' says User canUse(Device)
  if Device isOwnedBy(User),
     User hasAcknowledged('email-security'),
     User hasAcknowledged('acceptable-use'),
     User hasAcknowledged('ecommerce-security').
~~~~
	
# SecPAL language #2

> In case of loss or theft of handheld, users MUST report AS SOON AS POSSIBLE (right after the loss has been noticed) the IT department or help desk, in order to take the appropriate measures.

~~~~.secpal
'company' says User can-say
  Device isLost
  if Device isOwnedBy(User).

'company' says User mustInform('enterprise-help-desk',
                               'device-lost')
  if D isOwnedBy(User),
     D isLost.
~~~~

# Predicate classes

- Split predicates into four classes
	- *can* - permitted actions
	- *has* - completed actions
	- *is* - properties
	- *must* - obligations

# What is in the policies?

Policy     Size   
---------  -----
SANS       33  
HiMSS      15
NHS        56
Sirens     20 
Edinburgh  25
---------  -----

