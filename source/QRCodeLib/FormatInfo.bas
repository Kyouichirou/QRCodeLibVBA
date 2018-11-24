Attribute VB_Name = "FormatInfo"
'---------------------------------------------------------------------------
' �`�����
'---------------------------------------------------------------------------
Option Private Module
Option Explicit

Private m_formatInfoValues()     As Variant
Private m_formatInfoMaskArray()  As Variant

Private m_initialized As Boolean

'------------------------------------------------------------------------------
' (�T�v)
'  �`������z�u���܂��
'
' (�p�����[�^)
'  moduleMatrix         : �V���{���̖��Ãp�^�[��
'  ecLevel              : ���������x��
'  maskPatternReference : �}�X�N�p�^�[���Q�Ǝq
'------------------------------------------------------------------------------
Public Sub Place(ByRef moduleMatrix() As Variant, _
                 ByVal ecLevel As ErrorCorrectionLevel, _
                 ByVal maskPatternReference As Long)

#If [DEBUG] Then
    Debug.Assert maskPatternReference >= 0 And _
                 maskPatternReference <= 7
#End If

    Call Initialize

    Dim formatInfoValue As Long
    formatInfoValue = GetFormatInfoValue(ecLevel, maskPatternReference)
    
    Dim temp As Long
    Dim v    As Long
    
    Dim i As Long
           
    Dim r1 As Long
    r1 = 0
    
    Dim c1 As Long
    c1 = UBound(moduleMatrix)
    
    For i = 0 To 7
        temp = IIf((formatInfoValue And (2 ^ i)) > 0, 1, 0) Xor m_formatInfoMaskArray(i)
        
        v = IIf(temp > 0, 3, -3)
        
        moduleMatrix(r1)(8) = v
        moduleMatrix(8)(c1) = v
        
        r1 = r1 + 1
        c1 = c1 - 1
        
        If r1 = 6 Then
            r1 = r1 + 1
        End If
    Next
    
    Dim r2 As Long
    r2 = UBound(moduleMatrix) - 6
    
    Dim c2 As Long
    c2 = 7
    
    For i = 8 To 14
        temp = IIf((formatInfoValue And (2 ^ i)) > 0, 1, 0) Xor m_formatInfoMaskArray(i)
               
        v = IIf(temp > 0, 3, -3)
        
        moduleMatrix(r2)(8) = v
        moduleMatrix(8)(c2) = v
        
        r2 = r2 + 1
        c2 = c2 - 1
        
        If c2 = 6 Then
            c2 = c2 - 1
        End If
    Next
    
End Sub

'------------------------------------------------------------------------------
' (�T�v)
'  �`�����̗\��̈��z�u���܂��
'------------------------------------------------------------------------------
Public Sub PlaceTempBlank(ByRef moduleMatrix() As Variant)

    Dim numModulesPerSide As Long
    numModulesPerSide = UBound(moduleMatrix) + 1
    
    Dim i As Long
    
    For i = 0 To 8
        ' �^�C�~�O�p�^�[���̗̈�ł͂Ȃ��ꍇ
        If i <> 6 Then
            moduleMatrix(8)(i) = -3
            moduleMatrix(i)(8) = -3
        End If
    Next
    
    For i = numModulesPerSide - 8 To numModulesPerSide - 1
        moduleMatrix(8)(i) = -3
        moduleMatrix(i)(8) = -3
    Next
    
    ' �Œ�Ã��W���[����z�u(�}�X�N�̓K�p�O�ɔz�u����)
    moduleMatrix(numModulesPerSide - 8)(8) = 2
    
End Sub

'------------------------------------------------------------------------------
' (�T�v)
'
' (�p�����[�^)
'  ecLevel              : ���������x��
'  maskPatternReference : �}�X�N�p�^�[���Q�Ǝq
'------------------------------------------------------------------------------
Private Function GetFormatInfoValue( _
    ByVal ecLevel As ErrorCorrectionLevel, ByVal maskPatternReference As Long) As Long

    Call Initialize

    Dim indicator As Long
    
    Select Case ecLevel
        Case ErrorCorrectionLevel.L
            indicator = 1
            
        Case ErrorCorrectionLevel.M
            indicator = 0
            
        Case ErrorCorrectionLevel.Q
            indicator = 3
            
        Case ErrorCorrectionLevel.H
            indicator = 2
            
        Case Else
            Call Err.Raise(5)
        
    End Select

    GetFormatInfoValue = m_formatInfoValues((indicator * 2 ^ 3) Or maskPatternReference)
    
End Function

'------------------------------------------------------------------------------
' (�T�v)
'  �I�u�W�F�N�g�����������܂��B
'------------------------------------------------------------------------------
Private Sub Initialize()

    If m_initialized Then Exit Sub

    m_initialized = True

    ' �`�����
    m_formatInfoValues = Array( _
        &H0&, &H537&, &HA6E&, &HF59&, &H11EB&, &H14DC&, &H1B85&, &H1EB2&, &H23D6&, &H26E1&, _
        &H29B8&, &H2C8F&, &H323D&, &H370A&, &H3853&, &H3D64&, &H429B&, &H47AC&, &H48F5&, &H4DC2&, _
        &H5370&, &H5647&, &H591E&, &H5C29&, &H614D&, &H647A&, &H6B23&, &H6E14&, &H70A6&, &H7591&, _
        &H7AC8&, &H7FFF& _
    )

    ' �`�����̃}�X�N�p�^�[��
    m_formatInfoMaskArray = Array(0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1)
        
End Sub

