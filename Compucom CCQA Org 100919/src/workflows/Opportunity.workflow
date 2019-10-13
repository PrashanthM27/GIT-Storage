<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Field_Update</fullName>
        <field>Fcst_Start_Date__c</field>
        <formula>CloseDate +90</formula>
        <name>Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>endd_date</fullName>
        <field>Fcst_End_Date__c</field>
        <formula>CloseDate +456</formula>
        <name>endd date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
