Introduction
============

Many employees bring their personal mobile devices to work. To control the access these devices have, 70% of companies publish *bring your own device* (BYOD) policies . These BYOD policies are written documents for employees to read and follow. They describe steps to take to secure devices appropriate to the workplace. The policies say how employees should access data, and who should authorise decisions.

Companies have a variety of means to implement their policies. Some companies may trust employees to follow the rules on their own. Alternatively *Mobile Device Management* (MDM) software can implement part of the policies: packages such as IBM’s MaaS360 and Blackberry’s BES  can configure devices to restrict functionality and manage apps. Research has looked at developing other tools such as UC-Droid  or BYODroid  which was used to implement parts of a NATO BYOD policy .

Commercial tools are limited in what polices they can enforce. Some tools can only enable simple on-off configuration settings, and ban explicitly black-listed apps. More sophisticated systems can use app-rewriting to recompile apps to tunnel traffic through a VPN, or geofencing to apply policies in predefined areas. These tools are not infallible. One survey found that 50% of companies with MDM software still had non-compliant devices in their networks . Whilst app wrapping can protect some apps, in general it is ineffective .

MDM software and research has, so far, focused on restricting apps and device functionality. But what are the concerns and restrictions described in the policies themselves? By analysing 5 BYOD policies, we present the common concerns and structures found in the policies themselves. The policies display various styles for writing policies, and differing concerns. In comparison to MDM software, the policies do not focus exclusively on restrictions but rather require employees acknowledge company rules and the policies describe trust relationships amongst different departments. This suggests little consensus on the best way to write such policies and that more research is needed.

BYOD Policies
=============

We analysed 5 policies from different sources to find common concerns. These five were chosen as they come from a variety of sources and industries. Two are advisory, published specialist institutions to help other companies implement their own policies. Three are policies used in a hospital, a company selling emergency sirens, and a university.

-   The SANS policy  is a hypothetical BYOD policy that a company could use as a starting point to base its own policy on. It is prescriptive and long, focussed on technical restrictions such as disabling device features.

-   The HiMSS policy  also is a hypothetical policy, for US hospital trusts planing to implement a BYOD policy. It is short, but and written from the perspective of the employee agreeing to the policy. This is different to the other policies where instead the policy is written as rules for employees to follow.

-   The NHS policy  is a BYOD policy used in a British hospital trust. It is long, and describes a complex policy in a large organisation with a complex hierarchy.

-   The final two policies are simpler, the fourth is taken from a company selling emergency sirens for cars , the fifth is by the University of Edinburgh. Both are short, relatively uncomplicated, but typical examples of policies found *in the wild*.

Not all the policies are written in the same style. Most are written from the perspective of a company or IT department telling an employee what to do. The HiMSS policy, however, is written as a contract where the user tells the company how they will behave. Most policies separate individual policy rules into small individual rules each which must be followed. The Edinburgh policy groups them together into two or three large rules, with different increasing sets of sub-rules for low and high risk employees to follow.

Translation to SecPAL
=====================

To help compare the policies, they were first translated them into a formal language . We use a dialect of SecPAL  that we used for describing app privacy preferences . SecPAL is designed to be readable, and requires an explicit authority to *speak* individual statements. This allows SecPAL-based languages to capture delegation relationships and the differences in style between policies. Understanding the contents of policies and making comparisons is easier when using SecPAL as it helps to remove the ambiguities of natural language .

Each of the policies are split into a series of rules. The SecPAL used to translate the rules has a structure similar to Datalog. An authority (the speaker) will decide that a fact is true, if it can be convinced of a series of conditional facts are also true.

<span>⟨speaker⟩</span> says $\\overbrace{\\text{{$\\langle\\text{X}\\rangle$} {$\\langle\\text{predicate}\\rangle$}}}^{\\text{\\sf fact}}$ if $\\overbrace{\\text{{$\\langle\\text{Y}\\rangle$} {$\\langle\\text{predicate}\\rangle$}}}^{\\text{condition}}\\cdots$.

A simple example is the following example from the Sirens-company policy. The policy states that devices may access various company resources. For each resource we create a SecPAL assertion that states that a device can access it.

<span>Sirens</span> Employees may use their mobile device to access the following company-owned resources: • Email • Calendars • Contacts • Documents • Etc.

    'department' says Device:D canAccess('email').
    'department' says Device:D canAccess('calendars').
    'department' says Device:D canAccess('contacts').
    'department' says Device:D canAccess('documents').
      

A more complex example can be taken from the NHS policy. Employees are not allowed to call non-domestic, or premium rate numbers on company-owned phones [1], however an exception can be made if approved by the appropriate manager. To implement this we have the default rule that international calls are banned, a second rule stating that it is allowed if an exemption is made, finally a third rule delegating the exemption making process to the employee’s manager.

<span>NHS</span> All mobile devices will be configured for national access only. Premium/international calls will be barred. International call barring and roaming arrangements can be lifted for specific periods, to be stipulated on request, on approval of the relevant manager/budget holder.

    'nhs-trust' says Device canCall(TelephoneNumber:X)
      if Device isOwnedBy('nhs-trust'),
         X isNationalNumber, X isStandardRateNumber.

    'nhs-trust' says Device canCall(TelephoneNumber:X)
      if Device isOwnedBy(Staff),
         Staff hasCallExemption.

    'nhs-trust' says Manager can-say
      Staff hasCallExemption
      if Manager isManagerOf(Staff).
      

The formalisation of the policies[2] and tooling for our variant of SecPAL[3] are available online.

Rule Structures
===============

The predicates used in the formalisation of the rules fall into 4 categories. *Can* predicates describe what their subjects can do; for instance whether a device can connect to a server. *Must* predicates describe obligations, such as reporting a lost device. *Has* predicates ensure an action has been completed in the past, such as approving an app. Finally, *is* predicates describe a typing property about their subjects.

The occurrence of each type of predicate is shown in . The use of each is also split by whether the predicate is a *decision* made by the policy, or a *condition* for making that decision. *Can* and *must* decisions feature in all policies excepting *can* decisions in the Edinburgh policy, in part due to the structure of the policy as discussed in . This is expected, these are access control decisions and reactions to events; both topics that existing MDM tools have focused on implementing. *Has* and *is* predicates are the majority of the conditions, but there are also decisions using them too.

Existing MDM tools present policies as a series of tick-boxes for what a device *can* and *must* do (). An administrator selects which policies each device must follow, a predominantly manual process. In our examination of the policies, as well as finding rules that describe what a device *can* do, we find rules that group devices by what they *have* or *are*. Selecting which restrictions to apply to a device is defined by policies; but existing MDM tools do not allow policies to be selected on the basis of policies. MDM tools perhaps need greater flexibility to fully implement all aspects of a BYOD policy.

<span> c c c c c c c c c c </span> & &&
Policy & & & & && & & &
SANS & & & & && & & &
HiMSS & & & & && <span>0</span>& <span>0</span>& &
NHS & & & & && & <span>0</span>& &
Sirens & & & & && & & &
Edinburgh & <span>0</span>& & & <span>0</span>&& & & &

<img src="maas360-policy.png" alt="Example policy from the MaaS360 MDM software." />

Common Concerns and Checks
==========================

Analysing each of the policies common concerns become apparent. A summary of predicates, with the same meaning, used in multiple policies by our translation is given in .

Acknowledgements, where individuals are asked to acknowledge other policies, and predicates linking devices to owners are used in all policies. Most policies described rules for when device features should be enabled and disabled. Configuring device features is a common feature to many MDM packages, but tracking what a user agrees to is not seen in leading MDM packages like MaaS360 or BES . Only 2 out of 5 policies had rules limiting what networks, servers, or access points a device could access; and only the two most complex policies had rules limiting what apps could be installed. This is surprising as a common feature of MDM tools is controlling how devices and apps access networks. Users have privacy preferences about apps , but not all companies try to control what apps employees install. Providing curated app stores and blacklisting apps is a feature common to many MDM programs. Not all policies express rules about which apps to install, however.

<span>c c c c c c</span>
Predicate & & & & &
5 mustAcknowledged & & & & &
5 hasAcknowledged & & & & &
5 isOwnedBy & & & & &
5 isDevice & & & & &
4 mustDisable & & & & &
4 isLost & & & & &
4 isEmployee & & & & &
4 isApp & & & & &
4 isActivated & & & & &
3 mustEnable & & & & &
3 mustWipe & & & & &
3 isEncrypted & & & & &
3 hasMet & & & & &
3 canMonitor & & & & &
2 mustInform & & & & &
2 isTelephoneNumber & & & & &
2 isString & & & & &
2 isSecurityLevel & & & & &
2 isInstallable & & & & &
2 isFeature & & & & &
2 isData & & & & &
2 isApprovedFor & & & & &
2 isApproved & & & & &
2 hasFeature & & & & &
2 hasDevice & & & & &
2 hasDepartment & & & & &
2 canUse & & & & &
2 canStore & & & & &
2 canInstall & & & & &
2 canConnectToServer & & & & &
2 canConnectToNetwork & & & & &
2 canConnectToAP & & & & &
2 canCall & & & & &
2 canBackupTo & & & & &

All the policies we looked at required employees to be aware of and acknowledge the existence of other policies. The use of acknowledgements is noteworthy because policies acknowledged may not be ones that are enforcible automatically. These other rules include ethical or legal guidelines and disclaimers about data-loss. Writing software to check a user is aware they may lose the data, and is behaving ethically may not be possible.

An aspect of acknowledgements is that they require a delegation of trust from the company to their employees. The employees have to be responsible for stating what they do or do not acknowledge. Delegation is key to other policy decisions in the policies. The IT department is delegated to audit apps. Users are responsible for reporting their device missing.

We summarise the number (and percentage) of rules in the policies using acknowledgements and delegation relationships in . For comparison, we also give the at the number of rules which describe some form of restriction. Delegation relationships form a significant proportion of all the policies. Acknowledgements are used extensively in the HiMSS policy, but rarely in the SANS policy. Overall acknowledgements form as much a part of the policies as do device restrictions. MDM software has focussed on implementing device restrictions and configurations; but it would seem that other aspects are equally important.

<span>l c c c c c</span> & & & & &
Rules in policy & 33 & 15 & 56 & 20 & 25
Rules using acknowledgement & & & & &
Rules using delegation & & & & &
Rules describing a restriction & & & & &

Authorities and Delegation
==========================

Each of the policies use delegation to describe rules. A delegation requires at least two parties: someone to hand off the decision, and someone to hand the decision to. They can be individuals, but often they are a role that several individuals may fulfil When translating the policies into SecPAL we created an authority to deliver the policy. In most cases we took the company (who had authored the document) as the authority. In the HiMSS policy, however, rules are phrased as a user stating what they will do.

Most policies used three authorities to make the bulk of the decisions. A primary authority expresses the bulk of the policy and delegation relationships. They act as the *voice* of the policy. The primary authority delegates to the technical authority for some decisions. They may maintain inventories of devices, approve apps for devices, and describe what users may connect to. Their job varies between policies, but in general they are delegated to in order to provide more detailed policy rules. The user is responsible for stating who they are, what devices they have, and what the status of their device is (is it lost or no longer required, for instance).

Some policies have more authorities, than others (). The NHS policy has various managers that approve decisions for their staff. There are different groups that make decisions for the clinical and business halves of the business. If a clinical user wishes to use an app with a patient they must seek approval from two policy groups, as well as their line manager. Others make less use of different authorities. In the Edinburgh policy, the records-management office states how a low or high risk must be configured. There is no delegation to others to further specify aspects of the policy. Delegation of responsibilities is an important part of BYOD policies. MDM software seems largely to ignore it, however. These tools instead allow IT staff to set fixed policies and push them to devices. No further requesting of information is typically needed or required.

<span>c l l</span> & Authorities & 10
& Primary Authority & company
& Technical Authority & it-department
& User Authority & user
& Authorities & 3
& Primary Authority & user
& Technical Authority & xyz-health-system
& User Authority & department
& Authorities & 11
& Primary Authority & nhs-trust
& Technical Authority & it-department
& User Authority & staff
& Authorities & 4
& Primary Authority & department
& Technical Authority & it-department
& User Authority & employee
& Authorities & 2
& Primary Authority & records-management
& Technical Authority &
& User Authority & employee

Conclusions
===========

We have looked at 5 different BYOD policies and presented a summary of their contents, their styles of presentation and the relationships within them. To analyse the policies we translated them into SecPAL. The translation from natural to formal language is somewhat subjective. We have tried to mitigate this by attempting to preserve the style of the original and by careful use of predicates between different policies. Working with a company to implement the SecPAL policy inside their business would help to ensure the formalisation is correct.

Comparing the policies we found a diverse range of concerns. Some of these concerns (the use of acknowledgements in particular) are not addressed by current MDM tools. The tools focus on device configuration, which are only part of the concerns of the BYOD policies. We also found the policies were presented in a variety of styles. Some, like SANS, are prescriptive and describe a company telling employees what to do. Others, like HiMSS, take the form of a user contract, where employees state that they acknowledge the companies rules and agree to follow them. The lack of commonality suggest there may be no perfect solution for implementing BYOD policies. Future tools must be flexible enough to express a range of policies, and model the trust relationships these policies contain.

[1] The NHS policy doesn’t distinguish between company and privately owned phones and applies to both.

[2] <https://github.com/apppal/apppal-byod-policy-translations>

[3] <https://github.com/apppal/libapppal>
