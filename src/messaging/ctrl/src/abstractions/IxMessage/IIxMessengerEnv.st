USING ix.framework.utils;

NAMESPACE ix.framework.messaging
    INTERFACE IIxMessengerEnv 
		/// <summary>
		/// Gets whether the messaging is suspended at this point in program.					
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.Resume()"/>
		/// </para>
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.Suspend()"/>
		/// </para>
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.MinLevel"/>
		/// </para>
		/// </summary>			
		METHOD IsSuspended: BOOL END_METHOD
		/// <summary>
		/// Gets the message digest method. 
		/// Message digest serves to fingerprint messages.
		/// </summary>			
		METHOD GetMessageDigestMethod : eIxMessageDigestMethod END_METHOD
		/// <summary>
		/// Sets the message digest method. 
		/// Message digest serves to fingerprint messages.
		/// </summary>			
		METHOD SetMessageDigestMethod VAR_INPUT inDigestMethod : eIxMessageDigestMethod; END_VAR END_METHOD
		/// <summary>
		/// Gets the minimal messaging level, the objects will post only messages for the levels of this or superior severity.					
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.Resume()"/>
		/// </para>
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.Suspend()"/>
		/// </para>
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.MinLevel"/>
		/// </para>
		/// </summary>			
		METHOD GetMinLevel : eIxMessageCategory END_METHOD
		/// <summary>
		/// Sets the minimal messaging level, the objects will post only messages for the levels of this or superior severity.					
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.Resume()"/>
		/// </para>
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.Suspend()"/>
		/// </para>
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.MinLevel"/>
		/// </para>
		/// </summary>			
		METHOD SetMinLevel VAR_INPUT inMessageCategory : eIxMessageCategory; END_VAR END_METHOD
		/// <summary>
		/// Resumes messaging from the all objects of this context, when the messaging was previously suspended by ```Suspend``` method.					
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.Suspend()"/>
		/// </para>
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.MinLevel"/>
		/// </para>
		/// </summary>			
		METHOD Resume END_METHOD
		/// <summary>
		/// Suspends messaging from the all objects of this context that would occur from this point in the call tree.						
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.Resume()"/>
		/// </para>
		/// <para>
		/// See also <see cref="PlcDocu.TcoCore.TcoMessengerSettings.MinLevel"/>
		/// </para>
		/// </summary>	
		METHOD Suspend END_METHOD
		METHOD GetStringBuilder : REF_TO StringBuilder END_METHOD
	END_INTERFACE
END_NAMESPACE
