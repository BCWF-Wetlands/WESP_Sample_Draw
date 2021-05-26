# Bug Triage Process BC Registries 

## Steps internal in team
1. A dev team member (QA or dev) identifies a bug
2. Create issue by using the Bug Templpate ("bug report"), and label it as "bug" and mark "New Issues" in the ZenHub Pipeline
3. Based on the Sprint Goal and the severity of the bug, decide if this bug should be fixed immediately
   - YES, fix now? Inform (in-person/ RocketChat) PO about the amount of effort to fix the bug & the impact on the committed work
   * Decision: High Priority = high severity + high criticality (low, medium or high) is based on 
   * Decision Criteria: User Impact, Volume of users, Data impact  
   * __Priority1__: In order to complete the story this bug has to be fixed asap, or Customer is Blocked without a workaround. 
   * All others are not labeled with "Priority"; they are placed in column "Bugs" for future prioritization
4. Bugs, that are not fixed in the current Sprint move to "New Issues"
5. At the bi weekly bug triage Meeting (Bi-weekly for 30 min.) : 

   a) QA reviews - the bugs in "New Issues" column - with team members (1 dev, 1 QA, 1 BA & SM)  
   b) Set Priority according to the following definition: 
    -  __Priority2__ - Major defect/ bug with an intended feature, but has a workaround that can wait till the next release. 
    -  __Priority3__ - Minor defect with a workaround, may relate to usability. Must be fixed in some future release. 

   c) Dev provides estimate for the bug.
   d) Set release version P2s any of the next 3 releases. P3s are sometime in the future.
   e) Place into the Bug Column/Pipeline in priority order.
   
* Preparation for this Bug Triage Meeting: QA check if there is a duplicate of this issue (remove duplicates) and confirms if all bugs are reproducable (some bugs could be fixed already) 

----
**Usability Gaps or missed requirements**
* Based on the Bug Triage Meeting the PO has to decide where this work fits into? - assign to a BA?
----


## Steps external by a user/ client
1. A user identifies a bug (in UAT or PROD)


----
## Improvements & Ideas
1. We need a way to proceed on new high-priority (e.g. blocking) bugs when PO is not available
2. Treshold for Releases (e.g. do we move bugs into next Sprint?!) 

   
   
   
   



