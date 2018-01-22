using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(Renderer))]
[RequireComponent(typeof(Collider))]
public class Painter : MonoBehaviour
{
    public Material simpleInkPaintMat;

    private Texture brushTexture; 
    private Texture mainTexture;
    private RenderTexture renderTexture;

    private int mainTexturePropertyID;
    private int paintUVPropertyID;
    private int brushTexturePropertyID;
    private int brushScalePropertyID;
    private int brushColorPropertyID;

    public float brushSize;



    void Start()
    {

        mainTexturePropertyID = Shader.PropertyToID("_MainTex");
        paintUVPropertyID = Shader.PropertyToID("_PaintUV");
        brushTexturePropertyID = Shader.PropertyToID("_Brush");
        brushScalePropertyID = Shader.PropertyToID("_BrushScale");
        brushColorPropertyID = Shader.PropertyToID("_ControlColor");

        mainTexture = simpleInkPaintMat.GetTexture(mainTexturePropertyID);
        brushTexture = simpleInkPaintMat.GetTexture(brushTexturePropertyID);

        renderTexture = new RenderTexture(mainTexture.width, mainTexture.height, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Default);

        Graphics.Blit(mainTexture, renderTexture);

        simpleInkPaintMat.SetTexture(mainTexturePropertyID, renderTexture);
    }

    void OnDestroy()
    {
        renderTexture.Release();
        simpleInkPaintMat.SetTexture(mainTexturePropertyID, mainTexture); 
    }


    void Update()
    {


        if (Input.GetMouseButton(0))
        {
            var ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hitInfo;
            if (Physics.Raycast(ray, out hitInfo))
            {
    
                Paint(hitInfo.textureCoord);
            }
        }
    }

    private void Paint(Vector2 uv)
    {
        var renderTextureBuffer = RenderTexture.GetTemporary(renderTexture.width, renderTexture.height);
        simpleInkPaintMat.SetVector(paintUVPropertyID, uv);
        simpleInkPaintMat.SetTexture(brushTexturePropertyID, brushTexture);
        simpleInkPaintMat.SetFloat(brushScalePropertyID, brushSize);
        simpleInkPaintMat.SetVector(brushColorPropertyID, new Vector4(0, 128, 255, 128));

        Graphics.Blit(renderTexture, renderTextureBuffer, simpleInkPaintMat);
        Graphics.Blit(renderTextureBuffer, renderTexture);
        RenderTexture.ReleaseTemporary(renderTextureBuffer); 
    }
}